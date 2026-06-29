import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class ICustomerShopsRepository {
  Future<List<ShopProfileModel>> getNearbyShops();
  Future<List<ProductModel>> getShopProducts(String shopId);
}
