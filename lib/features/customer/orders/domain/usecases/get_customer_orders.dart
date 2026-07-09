import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/domain/repositories/i_orders_repository.dart';

class GetCustomerOrders {
  final IOrdersRepository repository;

  GetCustomerOrders(this.repository);

  Stream<List<OrderModel>> call() {
    return repository.getCustomerOrders();
  }
}
