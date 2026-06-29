import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/domain/repositories/i_shop_products_repository.dart';

class GetShopProducts {
  final IShopProductsRepository _repository;

  GetShopProducts(this._repository);

  Stream<List<ProductModel>> call(String shopId) {
    return _repository.getShopProducts(shopId);
  }
}
