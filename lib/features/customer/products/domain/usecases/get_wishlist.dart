import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';

class GetWishlist {
  final ICustomerProductsRepository repository;

  GetWishlist({required this.repository});

  Future<List<WishlistItem>> call() async {
    return await repository.getWishlist();
  }
}
