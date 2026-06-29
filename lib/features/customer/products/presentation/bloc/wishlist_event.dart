import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class WishlistEvent {}

class LoadWishlist extends WishlistEvent {}

class AddProductToWishlist extends WishlistEvent {
  final ProductModel product;
  final ShopProfileModel shop;

  AddProductToWishlist({required this.product, required this.shop});
}

class RemoveProductFromWishlist extends WishlistEvent {
  final String productId;

  RemoveProductFromWishlist({required this.productId});
}

class ClearAllWishlist extends WishlistEvent {}

class ResetWishlistState extends WishlistEvent {}
