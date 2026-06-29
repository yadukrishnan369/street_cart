import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItem> items;

  WishlistLoaded({required this.items});

  bool isWishlisted(String productId) {
    return items.any((item) => item.product.id == productId);
  }
}

class WishlistError extends WishlistState {
  final String message;

  WishlistError({required this.message});
}
