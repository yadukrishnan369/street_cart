import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/cart/domain/repositories/i_cart_repository.dart';

class GetProductById {
  final ICartRepository repository;

  GetProductById({required this.repository});

  Future<ProductModel> call(String productId) async {
    return await repository.getProductById(productId);
  }
}
