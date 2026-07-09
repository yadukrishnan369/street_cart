import 'package:street_cart/features/customer/orders/domain/repositories/i_orders_repository.dart';

class CancelOrder {
  final IOrdersRepository repository;

  CancelOrder(this.repository);

  Future<void> call(String orderId) {
    return repository.cancelOrder(orderId);
  }
}
