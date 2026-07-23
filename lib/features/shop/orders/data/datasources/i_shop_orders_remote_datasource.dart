import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

abstract class IShopOrdersRemoteDataSource {
  Stream<List<OrderModel>> watchShopOrders(String shopId);
  Future<void> updateOrderStatus(String orderId, String newStatus);
  Future<void> updateReturnStatus(
    String orderId,
    String returnStatus, {
    bool refundViaHand = false,
    double refundAmount = 0.0,
  });
  Future<void> processRefund(
    String orderId,
    double refundAmount,
    String refundStatus,
  );
}
