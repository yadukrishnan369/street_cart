import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';

abstract class ICustomerProductsRemoteDataSource {
  Future<List<ProductModel>> getNearbyProducts();
  Future<List<ShopProfileModel>> getNearbyShops();
  Future<void> addToWishlist(ProductModel product, ShopProfileModel shop);
  Future<void> removeFromWishlist(String productId);
  Future<List<WishlistItem>> getWishlist();
  Future<void> clearWishlist();
}
