import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/core/utils/location_helper.dart';
import 'package:street_cart/features/customer/shops/data/datasources/customer_shops_remote_datasource.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class CustomerShopsRemoteDataSourceImpl
    implements ICustomerShopsRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CustomerShopsRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;
  // Fetch Nearby Shops
  @override
  Future<List<ShopProfileModel>> getNearbyShops() async {
    try {
      final user = _auth.currentUser;
      double? customerLat;
      double? customerLng;

      if (user != null) {
        final doc = await _firestore
            .collection('customers')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final data = doc.data();
          if (data != null && data['location'] != null) {
            final loc = data['location'] as Map<String, dynamic>;
            customerLat = (loc['latitude'] as num?)?.toDouble();
            customerLng = (loc['longitude'] as num?)?.toDouble();
          }
        }
      }

      // Fetch all shops
      final snap = await _firestore.collection('shops').get();

      final allShops = <ShopProfileModel>[];
      for (final doc in snap.docs) {
        final data = doc.data();

        var shop = ShopProfileModel.fromMap(data, doc.id);

        // If rating is 0, calculate average Rating
        if (shop.rating == 0.0) {
          final prodSnap = await _firestore
              .collection('products')
              .where('shop_id', isEqualTo: shop.uid)
              .get();

          double totalRatingSum = 0.0;
          int totalCount = 0;
          for (final pDoc in prodSnap.docs) {
            final pData = pDoc.data();
            final pRating = (pData['rating'] as num?)?.toDouble() ?? 0.0;
            final pCount = (pData['reviews_count'] as num?)?.toInt() ?? 0;
            if (pRating > 0) {
              totalRatingSum += (pRating * (pCount > 0 ? pCount : 1));
              totalCount += (pCount > 0 ? pCount : 1);
            }
          }
          if (totalCount > 0) {
            final avg = totalRatingSum / totalCount;
            shop = shop.copyWith(rating: avg, reviewsCount: totalCount);
          }
        }

        allShops.add(shop);
      }

      // Filter by approval/suspension status
      var filteredShops = allShops
          .where((shop) => shop.isApproved && !shop.isSuspended)
          .toList();

      if (customerLat != null && customerLng != null) {
        filteredShops = filteredShops.where((shop) {
          if (shop.latitude == null || shop.longitude == null) {
            print('Shop "${shop.shopName}" has no coordinates');
            return false;
          }
          final distance = LocationHelper.calculateDistance(
            customerLat!,
            customerLng!,
            shop.latitude!,
            shop.longitude!,
          );
          final inRange = distance <= shop.deliveryRadius;
          return inRange;
        }).toList();
      } else {
        print(
          'Customer location is null. Returning empty list because location is off.',
        );
        return [];
      }

      return filteredShops;
    } catch (e) {
      throw Exception('Failed to fetch nearby shops: $e');
    }
  }

  // Get Shop Products
  @override
  Future<List<ProductModel>> getShopProducts(String shopId) async {
    try {
      final snap = await _firestore
          .collection('products')
          .where('shop_id', isEqualTo: shopId)
          .get();

      return snap.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .where((p) => p.isActive && !p.disabledByAdmin)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products for shop $shopId: $e');
    }
  }
}
