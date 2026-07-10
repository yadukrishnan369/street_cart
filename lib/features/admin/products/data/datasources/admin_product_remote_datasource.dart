import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class IAdminProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<List<ShopProfileModel>> getAllShops();
  Future<List<String>> getBusinessCategoryNames();
  Future<List<String>> getProductCategoryNames();
  Future<void> updateProductDisabledStatus(String productId, bool disabled);
  Future<void> deleteProduct(String productId);
  Future<ProductModel> getProductById(String productId);
  Future<double> getPlatformCommission();
  Future<int> getProductOrderCount(String productId);
}
