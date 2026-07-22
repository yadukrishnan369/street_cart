import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

abstract class IOrdersRepository {
  Stream<List<OrderModel>> getCustomerOrders();
  Future<void> cancelOrder(String orderId);
  Future<void> cancelOrderItem(String orderId, String orderItemId);
  Future<void> updateOrderAddress(String orderId, AddressModel address);
  Future<void> submitReturnRequest({
    required String orderId,
    required String itemId,
    required String reason,
    required String details,
  });
}
