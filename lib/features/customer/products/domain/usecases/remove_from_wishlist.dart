import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';

class RemoveFromWishlist {
  final ICustomerProductsRepository repository;

  RemoveFromWishlist({required this.repository});

  Future<void> call(String productId) async {
    return await repository.removeFromWishlist(productId);
  }
}
