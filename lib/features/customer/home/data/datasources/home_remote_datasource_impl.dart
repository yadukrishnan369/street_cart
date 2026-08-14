import 'package:shared_preferences/shared_preferences.dart';
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
  final SharedPreferences _sharedPreferences;

  HomeRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required LocationService locationService,
    required SharedPreferences sharedPreferences,
  }) : _auth = auth,
       _firestore = firestore,
       _locationService = locationService,
       _sharedPreferences = sharedPreferences;
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
          recommendedProducts: [],
          popularProducts: [],
          newArrivals: [],
          bestSellers: [],
          hasMoreShops: false,
          allNearbyShops: [],
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
      List<ShopProfileModel> allNearbyShops = [];
      bool hasMoreShops = false;
      List<ProductModel> nearbyProducts = [];
      List<ProductModel> recommendedProducts = [];
      List<ProductModel> popularProducts = [];
      List<ProductModel> newArrivals = [];
      List<ProductModel> bestSellers = [];

      if (lat != null && lng != null) {
        allNearbyShops = await _getNearbyShops(lat, lng);
        hasMoreShops = allNearbyShops.length > 5;
        nearbyShops = allNearbyShops.take(5).toList();
        if (allNearbyShops.isNotEmpty) {
          final shopIds = allNearbyShops.map((s) => s.uid).toList();
          nearbyProducts = await _getShopsProducts(shopIds);

          // Recommended Products based on recent search queries and users previous orders/categories
          final orderCats = <String>{};
          try {
            final ordersSnap = await _firestore
                .collection('orders')
                .where('customer_id', isEqualTo: user.uid)
                .get();
            for (final doc in ordersSnap.docs) {
              final items = doc.data()['items'] as List<dynamic>? ?? [];
              for (final item in items) {
                final pId = item['product_id'] as String?;
                if (pId != null) {
                  // Find product category in nearby products
                  final matchedProduct = nearbyProducts.firstWhere(
                    (p) => p.id == pId,
                    orElse: () => ProductModel(
                      id: '',
                      shopId: '',
                      name: '',
                      originalPrice: 0.0,
                      description: '',
                      stockQuantity: 0,
                      category: '',
                      sizeStandard: '',
                    ),
                  );
                  if (matchedProduct.id.isNotEmpty &&
                      matchedProduct.category.isNotEmpty) {
                    orderCats.add(matchedProduct.category);
                  }
                }
              }
            }
          } catch (_) {}

          final recentQueries =
              _sharedPreferences.getStringList('recent_queries') ?? <String>[];
          final recommendedSet = <String>{};

          // Add products matching recent search queries first
          if (recentQueries.isNotEmpty) {
            for (final query in recentQueries) {
              final keywords = <String>{};
              final words = query.split(RegExp(r'\s+'));
              for (final word in words) {
                final cleaned = word.trim().toLowerCase();
                if (cleaned.length >= 3) {
                  keywords.add(cleaned);
                }
              }
              if (keywords.isNotEmpty) {
                final queryMatches = nearbyProducts.where((p) {
                  if (recommendedSet.contains(p.id)) return false;
                  final nameLower = p.name.toLowerCase();
                  final catLower = p.category.toLowerCase();
                  final descLower = p.description.toLowerCase();
                  return keywords.any((kw) {
                    return nameLower.contains(kw) ||
                        catLower.contains(kw) ||
                        descLower.contains(kw);
                  });
                }).toList();
                for (final p in queryMatches) {
                  recommendedProducts.add(p);
                  recommendedSet.add(p.id);
                }
              }
            }
          }

          // Add products matching previously ordered product categories
          if (orderCats.isNotEmpty) {
            final orderCatProducts = nearbyProducts
                .where(
                  (p) => orderCats.any(
                    (cat) => cat.toLowerCase() == p.category.toLowerCase(),
                  ),
                )
                .toList();
            for (final p in orderCatProducts) {
              if (!recommendedSet.contains(p.id)) {
                recommendedProducts.add(p);
                recommendedSet.add(p.id);
              }
            }
          }

          // Popular Products based on more sales count + rating
          final sortedPopular = List<ProductModel>.from(nearbyProducts)
            ..sort((a, b) {
              final scoreA = a.salesCount + a.rating;
              final scoreB = b.salesCount + b.rating;
              return scoreB.compareTo(scoreA);
            });
          popularProducts = sortedPopular
              .where((p) => p.rating >= 3.5 || p.salesCount > 0)
              .toList();

          // New arrivals Products based on recently added products
          newArrivals = List<ProductModel>.from(nearbyProducts)
            ..sort((a, b) {
              if (a.createdAt == null && b.createdAt == null) return 0;
              if (a.createdAt == null) return 1;
              if (b.createdAt == null) return -1;
              return b.createdAt!.compareTo(a.createdAt!);
            });

          // Best sellers Products based on with high sales
          final sortedSales = List<ProductModel>.from(nearbyProducts)
            ..sort((a, b) => b.salesCount.compareTo(a.salesCount));
          bestSellers = sortedSales.where((p) => p.salesCount > 0).toList();

          // Trending Nearby Products based on most orders product within the last 10 days
          final recentSales = <String, int>{};
          try {
            final tenDaysAgo = DateTime.now().subtract(
              const Duration(days: 10),
            );
            final recentOrdersSnap = await _firestore
                .collection('orders')
                .where(
                  'created_at',
                  isGreaterThanOrEqualTo: Timestamp.fromDate(tenDaysAgo),
                )
                .get();
            for (final doc in recentOrdersSnap.docs) {
              final items = doc.data()['items'] as List<dynamic>? ?? [];
              for (final item in items) {
                final pId = item['product_id'] as String?;
                final qty = (item['quantity'] as num?)?.toInt() ?? 1;
                if (pId != null) {
                  recentSales[pId] = (recentSales[pId] ?? 0) + qty;
                }
              }
            }
          } catch (_) {}

          nearbyProducts.sort((a, b) {
            final salesA = recentSales[a.id] ?? 0;
            final salesB = recentSales[b.id] ?? 0;
            if (salesA != salesB) {
              return salesB.compareTo(salesA);
            }
            if (a.salesCount != b.salesCount) {
              return b.salesCount.compareTo(a.salesCount);
            }
            if (a.createdAt == null && b.createdAt == null) return 0;
            if (a.createdAt == null) return 1;
            if (b.createdAt == null) return -1;
            return b.createdAt!.compareTo(a.createdAt!);
          });
        }
      }

      return HomeData(
        address: address,
        categories: categories,
        nearbyShops: nearbyShops,
        nearbyProducts: nearbyProducts,
        recommendedProducts: recommendedProducts,
        popularProducts: popularProducts,
        newArrivals: newArrivals,
        bestSellers: bestSellers,
        hasMoreShops: hasMoreShops,
        allNearbyShops: allNearbyShops,
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
      final ordersSnap = await _firestore.collection('orders').get();
      final shopSoldItems = <String, int>{};
      for (final doc in ordersSnap.docs) {
        final data = doc.data();
        final items = data['items'] as List<dynamic>? ?? [];
        for (final item in items) {
          final sId = item['shop_id'] as String?;
          final qty = (item['quantity'] as num?)?.toInt() ?? 1;
          if (sId != null) {
            shopSoldItems[sId] = (shopSoldItems[sId] ?? 0) + qty;
          }
        }
      }

      final filteredShops = allShops.where((shop) {
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

      filteredShops.sort((a, b) {
        final aSold = shopSoldItems[a.uid] ?? 0;
        final bSold = shopSoldItems[b.uid] ?? 0;
        final aPriority = aSold + a.reviewsCount;
        final bPriority = bSold + b.reviewsCount;
        return bPriority.compareTo(aPriority);
      });

      return filteredShops;
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
