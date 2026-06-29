import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class HomeData {
  final String? address;
  final List<String> categories;
  final List<ShopProfileModel> nearbyShops;
  final List<ProductModel> nearbyProducts;

  HomeData({
    this.address,
    required this.categories,
    required this.nearbyShops,
    required this.nearbyProducts,
  });
}

abstract class IHomeRepository {
  Future<HomeData> getHomeData();
}
