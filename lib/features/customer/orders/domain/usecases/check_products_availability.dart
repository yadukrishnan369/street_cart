import 'package:street_cart/features/customer/orders/domain/repositories/i_orders_repository.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

class CheckProductsAvailability {
  final IOrdersRepository repository;

  CheckProductsAvailability(this.repository);

  Future<Map<String, String>> call(List<OrderItemModel> items) {
    return repository.checkProductsAvailability(items);
  }
}
