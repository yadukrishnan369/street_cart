import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class CustomerProductsData {
  final List<ProductModel> products;
  final List<ShopProfileModel> shops;

  CustomerProductsData({
    required this.products,
    required this.shops,
  });
}

class WishlistItem {
  final ProductModel product;
  final ShopProfileModel shop;

  WishlistItem({required this.product, required this.shop});
}

abstract class ICustomerProductsRepository {
  Future<CustomerProductsData> getProductsData();
  Future<void> addToWishlist(ProductModel product, ShopProfileModel shop);
  Future<void> removeFromWishlist(String productId);
  Future<List<WishlistItem>> getWishlist();
  Future<void> clearWishlist();
}
