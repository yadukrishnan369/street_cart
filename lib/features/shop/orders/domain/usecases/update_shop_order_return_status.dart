import 'package:street_cart/features/shop/orders/domain/repositories/i_shop_orders_repository.dart';

class UpdateShopOrderReturnStatus {
  final IShopOrdersRepository repository;

  UpdateShopOrderReturnStatus(this.repository);

  Future<void> call(String orderId, String returnStatus) {
    return repository.updateReturnStatus(orderId, returnStatus);
  }
}
