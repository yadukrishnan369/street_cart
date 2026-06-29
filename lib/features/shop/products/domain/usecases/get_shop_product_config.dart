import 'package:street_cart/features/shop/products/domain/repositories/i_shop_products_repository.dart';

class GetShopProductConfig {
  final IShopProductsRepository _repository;

  GetShopProductConfig(this._repository);

  Future<Map<String, dynamic>> call(String shopId) async {
    return await _repository.getShopProductConfig(shopId);
  }
}
