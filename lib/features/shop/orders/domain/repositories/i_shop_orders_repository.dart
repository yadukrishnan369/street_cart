import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

abstract class IShopOrdersRepository {
  Stream<List<OrderModel>> watchShopOrders(String shopId);
  Future<void> updateOrderStatus(String orderId, String newStatus);
}
