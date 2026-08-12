import 'package:street_cart/features/customer/orders/domain/repositories/i_orders_repository.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/get_customer_order_details.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/send_shop_notification.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/send_admin_notification.dart';

class CancelOrderItem {
  final IOrdersRepository repository;
  final GetCustomerOrderDetails getOrderDetails;
  final SendShopNotification sendShopNotification;
  final SendAdminNotification sendAdminNotification;

  CancelOrderItem({
    required this.repository,
    required this.getOrderDetails,
    required this.sendShopNotification,
    required this.sendAdminNotification,
  });

  Future<void> call(String orderId, String orderItemId) async {
    final order = await getOrderDetails(orderId);

    await repository.cancelOrderItem(orderId, orderItemId);

    if (order != null) {
      final cancelledItem = order.items.cast<dynamic>().firstWhere(
        (item) => item.id == orderItemId,
        orElse: () => null,
      );
      if (cancelledItem != null) {
        final shopId = cancelledItem.shopId as String;
        // Send order item cancel notification to shop
        try {
          await sendShopNotification.sendOrderCancelledByCustomer(
            shopId: shopId,
            orderId: orderId,
          );
        } catch (_) {}
      }
    }
    // Send order item cancel notification to admin
    try {
      await sendAdminNotification.sendOrderCancelled(orderId: orderId);
    } catch (_) {}
  }
}
