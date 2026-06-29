import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';

class ClearWishlist {
  final ICustomerProductsRepository repository;

  ClearWishlist({required this.repository});

  Future<void> call() async {
    return await repository.clearWishlist();
  }
}
