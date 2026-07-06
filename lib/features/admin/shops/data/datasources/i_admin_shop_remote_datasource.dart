import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class IAdminShopRemoteDataSource {
  Future<List<ShopProfileModel>> getAllApprovedShops();
  Future<void> updateShopSuspensionStatus(String shopId, bool isSuspended);
  Future<List<String>> getBusinessCategoryNames();
  Future<ShopProfileModel> getShopById(String shopId);
  Future<void> deleteShop(String shopId);
  Future<List<ProductModel>> getProductsByShopId(String shopId);
}
