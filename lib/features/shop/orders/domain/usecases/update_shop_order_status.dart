import 'package:street_cart/features/shop/orders/domain/repositories/i_shop_orders_repository.dart';

class UpdateShopOrderStatus {
  final IShopOrdersRepository repository;

  UpdateShopOrderStatus(this.repository);

  Future<void> call(String orderId, String newStatus) {
    return repository.updateOrderStatus(orderId, newStatus);
  }
}
