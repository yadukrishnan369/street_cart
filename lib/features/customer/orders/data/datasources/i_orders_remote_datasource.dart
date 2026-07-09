import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

abstract class IOrdersRemoteDataSource {
  Stream<List<OrderModel>> getCustomerOrders();
  Future<void> cancelOrder(String orderId);
}
