import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/notification/domain/repositories/i_customer_notifications_repository.dart';

class GetCustomerOrderDetails {
  final ICustomerNotificationsRepository _repository;

  GetCustomerOrderDetails(this._repository);

  Future<OrderModel?> call(String orderId) async {
    return _repository.getOrderById(orderId);
  }
}
