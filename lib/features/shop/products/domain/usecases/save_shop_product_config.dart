import 'package:street_cart/features/shop/products/domain/repositories/i_shop_products_repository.dart';

class SaveShopProductConfig {
  final IShopProductsRepository _repository;

  SaveShopProductConfig(this._repository);

  Future<void> call(String shopId, Map<String, dynamic> config) async {
    return await _repository.saveShopProductConfig(shopId, config);
  }
}
