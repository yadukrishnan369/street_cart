import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

abstract class IShopOrdersRepository {
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
  Future<Map<String, Map<String, bool>>> checkProductsStatus(
    List<String> productIds,
  );
}
