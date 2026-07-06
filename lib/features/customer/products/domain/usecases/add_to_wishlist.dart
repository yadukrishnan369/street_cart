import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class AddToWishlist {
  final ICustomerProductsRepository repository;

  AddToWishlist({required this.repository});

  Future<void> call(
    ProductModel product,
    ShopProfileModel shop, {
    String? selectedColor,
    String? selectedSize,
  }) async {
    return await repository.addToWishlist(
      product,
      shop,
      selectedColor: selectedColor,
      selectedSize: selectedSize,
    );
  }
}
