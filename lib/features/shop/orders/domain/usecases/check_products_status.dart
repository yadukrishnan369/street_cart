import 'package:street_cart/features/shop/orders/domain/repositories/i_shop_orders_repository.dart';

class CheckProductsStatus {
  final IShopOrdersRepository repository;

  CheckProductsStatus(this.repository);

  Future<Map<String, Map<String, bool>>> call(List<String> productIds) async {
    return repository.checkProductsStatus(productIds);
  }
}
