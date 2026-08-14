import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class HomeData {
  final String? address;
  final List<String> categories;
  final List<ShopProfileModel> nearbyShops;
  final List<ProductModel> nearbyProducts;
  final List<ProductModel> recommendedProducts;
  final List<ProductModel> popularProducts;
  final List<ProductModel> newArrivals;
  final List<ProductModel> bestSellers;
  final bool hasMoreShops;
  final List<ShopProfileModel> allNearbyShops;

  HomeData({
    this.address,
    required this.categories,
    required this.nearbyShops,
    required this.nearbyProducts,
    required this.recommendedProducts,
    required this.popularProducts,
    required this.newArrivals,
    required this.bestSellers,
    required this.hasMoreShops,
    required this.allNearbyShops,
  });

  List<ProductModel> _filter(
    List<ProductModel> products,
    String selectedCategory,
  ) {
    if (selectedCategory == 'All') {
      return products;
    }
    final shopCats = {
      for (final s in allNearbyShops) s.uid: s.category.toLowerCase(),
    };
    return products.where((p) {
      final shopCat = shopCats[p.shopId] ?? '';
      return shopCat == selectedCategory.toLowerCase();
    }).toList();
  }

  List<ProductModel> getRecommended(String selectedCategory) {
    return _filter(recommendedProducts, selectedCategory).take(6).toList();
  }

  bool hasMoreRecommended(String selectedCategory) {
    return _filter(recommendedProducts, selectedCategory).length > 6;
  }

  List<ProductModel> getPopular(String selectedCategory) {
    return _filter(popularProducts, selectedCategory).take(6).toList();
  }

  bool hasMorePopular(String selectedCategory) {
    return _filter(popularProducts, selectedCategory).length > 6;
  }

  List<ProductModel> getTrending(String selectedCategory) {
    return _filter(nearbyProducts, selectedCategory).take(6).toList();
  }

  bool hasMoreTrending(String selectedCategory) {
    return _filter(nearbyProducts, selectedCategory).length > 6;
  }

  List<ProductModel> getNewArrivals(String selectedCategory) {
    return _filter(newArrivals, selectedCategory).take(6).toList();
  }

  bool hasMoreNewArrivals(String selectedCategory) {
    return _filter(newArrivals, selectedCategory).length > 6;
  }

  List<ProductModel> getBestSellers(String selectedCategory) {
    return _filter(bestSellers, selectedCategory).take(6).toList();
  }

  bool hasMoreBestSellers(String selectedCategory) {
    return _filter(bestSellers, selectedCategory).length > 6;
  }
}

abstract class IHomeRepository {
  Future<HomeData> getHomeData();
}
