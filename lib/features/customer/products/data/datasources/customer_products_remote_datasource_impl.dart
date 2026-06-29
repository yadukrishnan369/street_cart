import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/core/utils/location_helper.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';
import 'customer_products_remote_datasource.dart';

class CustomerProductsRemoteDataSourceImpl
    implements ICustomerProductsRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CustomerProductsRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  @override
  Future<List<ShopProfileModel>> getNearbyShops() async {
    try {
      final user = _auth.currentUser;
      double? customerLat;
      double? customerLng;

      if (user != null) {
        final doc = await _firestore.collection('customers').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null && data['location'] != null) {
            final loc = data['location'] as Map<String, dynamic>;
            customerLat = (loc['latitude'] as num?)?.toDouble();
            customerLng = (loc['longitude'] as num?)?.toDouble();
          }
        }
      }

      if (customerLat == null || customerLng == null) {
        print('Customer location is null. Returning empty list because location is off.');
        return [];
      }

      final shopsSnap = await _firestore
          .collection('shops')
          .where('is_approved', isEqualTo: true)
          .get();

      final allShops = shopsSnap.docs
          .map((doc) => ShopProfileModel.fromMap(doc.data(), doc.id))
          .where((shop) => !shop.isSuspended)
          .toList();

      final filteredShops = allShops.where((shop) {
        if (shop.latitude == null || shop.longitude == null) return false;
        final distance = LocationHelper.calculateDistance(
          customerLat!,
          customerLng!,
          shop.latitude!,
          shop.longitude!,
        );
        return distance <= shop.deliveryRadius;
      }).toList();

      return filteredShops;
    } catch (e) {
      throw Exception('Failed to fetch nearby shops: $e');
    }
  }

  @override
  Future<List<ProductModel>> getNearbyProducts() async {
    try {
      final shops = await getNearbyShops();
      if (shops.isEmpty) return [];

      final shopIds = shops.map((s) => s.uid).toList();

      final snap = await _firestore.collection('products').get();

      final allProducts = snap.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();

      final filtered = allProducts
          .where(
            (p) =>
                p.isActive && !p.disabledByAdmin && shopIds.contains(p.shopId),
          )
          .toList();

      // Sort products by newest first
      filtered.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      return filtered;
    } catch (e) {
      throw Exception('Failed to fetch nearby products: $e');
    }
  }

  @override
  Future<void> addToWishlist(ProductModel product, ShopProfileModel shop) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final docRef = _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('wishlist')
          .doc(product.id);

      await docRef.set({
        'product_id': product.id,
        'added_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('wishlist')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }

  @override
  Future<List<WishlistItem>> getWishlist() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final snap = await _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('wishlist')
          .orderBy('added_at', descending: true)
          .get();

      if (snap.docs.isEmpty) return [];

      final productIds = <String>[];
      final addedAtMap = <String, DateTime?>{};
      for (final doc in snap.docs) {
        try {
          final data = doc.data();
          final pId = data['product_id'] as String?;
          if (pId != null && pId.isNotEmpty) {
            productIds.add(pId);
            final Timestamp? addedAtStamp = data['added_at'] as Timestamp?;
            addedAtMap[pId] = addedAtStamp?.toDate();
          }
        } catch (e) {
          print('Error parsing wishlist item ID: $e');
        }
      }

      if (productIds.isEmpty) return [];

      final fetchedProducts = <ProductModel>[];
      for (var i = 0; i < productIds.length; i += 30) {
        final chunk = productIds.sublist(i, i + 30 > productIds.length ? productIds.length : i + 30);
        final productsSnap = await _firestore
            .collection('products')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        for (final productDoc in productsSnap.docs) {
          try {
            fetchedProducts.add(ProductModel.fromMap(productDoc.data(), productDoc.id));
          } catch (e) {
            print('Error parsing product ${productDoc.id}: $e');
          }
        }
      }

      if (fetchedProducts.isEmpty) return [];

      final shopIds = fetchedProducts.map((p) => p.shopId).toSet().toList();
      final fetchedShopsMap = <String, ShopProfileModel>{};
      
      for (var i = 0; i < shopIds.length; i += 30) {
        final chunk = shopIds.sublist(i, i + 30 > shopIds.length ? shopIds.length : i + 30);
        final shopsSnap = await _firestore
            .collection('shops')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        for (final shopDoc in shopsSnap.docs) {
          try {
            fetchedShopsMap[shopDoc.id] = ShopProfileModel.fromMap(shopDoc.data(), shopDoc.id);
          } catch (e) {
            print('Error parsing shop ${shopDoc.id}: $e');
          }
        }
      }

      final itemsWithTime = <MapEntry<WishlistItem, DateTime?>>[];
      for (final product in fetchedProducts) {
        final shop = fetchedShopsMap[product.shopId] ?? ShopProfileModel(
          uid: product.shopId,
          ownerName: '',
          shopName: 'Unknown Shop',
          email: '',
          category: '',
          description: '',
          gstNumber: '',
          businessLicenseUrl: '',
          ownerIdUrl: '',
          isApproved: true,
          role: 'shop',
          isProfileCompleted: true,
          profileImageUrl: '',
          phone: '',
          deliveryRadius: 5.0,
          fullAddress: '',
          landmark: '',
          city: '',
          pincode: '',
          district: '',
          state: '',
          paymentMethods: [],
        );
        final addedAt = addedAtMap[product.id];
        itemsWithTime.add(MapEntry(
          WishlistItem(product: product, shop: shop),
          addedAt,
        ));
      }

      itemsWithTime.sort((a, b) {
        if (a.value == null && b.value == null) return 0;
        if (a.value == null) return 1;
        if (b.value == null) return -1;
        return b.value!.compareTo(a.value!);
      });

      return itemsWithTime.map((entry) => entry.key).toList();
    } catch (e) {
      throw Exception('Failed to fetch wishlist: $e');
    }
  }

  @override
  Future<void> clearWishlist() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final wishlistRef = _firestore
          .collection('customers')
          .doc(user.uid)
          .collection('wishlist');

      final snap = await wishlistRef.get();
      if (snap.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear wishlist: $e');
    }
  }
}
