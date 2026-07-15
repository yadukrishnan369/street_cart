import 'package:street_cart/features/customer/orders/domain/repositories/i_orders_repository.dart';

class CancelOrderItem {
  final IOrdersRepository repository;

  CancelOrderItem(this.repository);

  Future<void> call(String orderId, String orderItemId) {
    return repository.cancelOrderItem(orderId, orderItemId);
  }
}
