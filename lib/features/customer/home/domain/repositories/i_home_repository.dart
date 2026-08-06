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

  HomeData({
    this.address,
    required this.categories,
    required this.nearbyShops,
    required this.nearbyProducts,
    required this.recommendedProducts,
    required this.popularProducts,
    required this.newArrivals,
    required this.bestSellers,
  });
}

abstract class IHomeRepository {
  Future<HomeData> getHomeData();
}
