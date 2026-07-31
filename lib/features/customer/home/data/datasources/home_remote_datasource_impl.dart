import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/core/services/location_service.dart';
import 'package:street_cart/core/utils/location_helper.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/home/domain/repositories/i_home_repository.dart';
import 'home_remote_datasource.dart';

class HomeRemoteDataSourceImpl implements IHomeRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final LocationService _locationService;

  HomeRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required LocationService locationService,
  }) : _auth = auth,
       _firestore = firestore,
       _locationService = locationService;
  // Get Customer Home Data
  @override
  Future<HomeData> getHomeData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return HomeData(
          address: null,
          categories: [],
          nearbyShops: [],
          nearbyProducts: [],
        );
      }

      final doc = await _firestore.collection('customers').doc(user.uid).get();
      String? address;
      double? lat;
      double? lng;

      if (doc.exists) {
        final data = doc.data();
        if (data != null &&
            data['location_permission'] == true &&
            data['location'] != null) {
          final loc = data['location'] as Map<String, dynamic>;
          lat = (loc['latitude'] as num?)?.toDouble();
          lng = (loc['longitude'] as num?)?.toDouble();

          if (lat != null && lng != null) {
            address = await _locationService.getAddressFromCoordinates(
              lat,
              lng,
            );
          }
        }
      }

      // Fetch Categories
      final categories = await _getProductCategories();

      List<ShopProfileModel> nearbyShops = [];
      List<ProductModel> nearbyProducts = [];

      if (lat != null && lng != null) {
        nearbyShops = await _getNearbyShops(lat, lng);
        if (nearbyShops.isNotEmpty) {
          final shopIds = nearbyShops.map((s) => s.uid).toList();
          nearbyProducts = await _getShopsProducts(shopIds);
        }
      }

      return HomeData(
        address: address,
        categories: categories,
        nearbyShops: nearbyShops,
        nearbyProducts: nearbyProducts,
      );
    } catch (e) {
      throw Exception('Failed to get home data: $e');
    }
  }

  // Fetch Product Category
  Future<List<String>> _getProductCategories() async {
    try {
      final catDoc = await _firestore
          .collection('config')
          .doc('categories')
          .get();
      final List<String> categories = [];
      if (catDoc.exists && catDoc.data() != null) {
        final rawProductCats =
            catDoc.data()!['product_categories'] as List<dynamic>?;
        if (rawProductCats != null) {
          for (final e in rawProductCats) {
            final name = e['name'] as String?;
            final isVisible = e['is_visible'] as bool? ?? true;
            if (name != null && name.isNotEmpty && isVisible) {
              categories.add(name);
            }
          }
        }
      }
      return categories;
    } catch (e) {
      return [];
    }
  }

  // Fetch Nearby Shops
  Future<List<ShopProfileModel>> _getNearbyShops(
    double customerLat,
    double customerLng,
  ) async {
    try {
      final shopsSnap = await _firestore
          .collection('shops')
          .where('is_approved', isEqualTo: true)
          .get();

      final allShops = <ShopProfileModel>[];
      for (final doc in shopsSnap.docs) {
        var shop = ShopProfileModel.fromMap(doc.data(), doc.id);
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
      return allShops.where((shop) {
        if (shop.isSuspended) return false;
        if (shop.latitude == null || shop.longitude == null) return false;

        final distance = LocationHelper.calculateDistance(
          customerLat,
          customerLng,
          shop.latitude!,
          shop.longitude!,
        );
        return distance <= shop.deliveryRadius;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get nearby shops: $e');
    }
  }

  // Fetch Nearby Shops Product
  Future<List<ProductModel>> _getShopsProducts(List<String> shopIds) async {
    try {
      if (shopIds.isEmpty) return [];

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
      throw Exception('Failed to get shop products: $e');
    }
  }
}
