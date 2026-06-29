import 'package:street_cart/features/shop/products/domain/repositories/i_shop_products_repository.dart';

class DeleteProduct {
  final IShopProductsRepository _repository;

  DeleteProduct(this._repository);

  Future<void> call(String shopId, String productId) async {
    return await _repository.deleteProduct(shopId, productId);
  }
}
