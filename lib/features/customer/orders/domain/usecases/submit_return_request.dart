import 'package:street_cart/features/customer/orders/domain/repositories/i_orders_repository.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/get_customer_order_details.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/send_shop_notification.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/send_admin_notification.dart';

class SubmitReturnRequest {
  final IOrdersRepository repository;
  final GetCustomerOrderDetails getOrderDetails;
  final SendShopNotification sendShopNotification;
  final SendAdminNotification sendAdminNotification;

  SubmitReturnRequest({
    required this.repository,
    required this.getOrderDetails,
    required this.sendShopNotification,
    required this.sendAdminNotification,
  });

  Future<void> call({
    required String orderId,
    required String itemId,
    required String reason,
    required String details,
  }) async {
    final order = await getOrderDetails(orderId);

    await repository.submitReturnRequest(
      orderId: orderId,
      itemId: itemId,
      reason: reason,
      details: details,
    );

    if (order != null) {
      final item = order.items.cast<dynamic>().firstWhere(
        (item) => item.id == itemId,
        orElse: () => null,
      );
      if (item != null) {
        final shopId = item.shopId as String;
        // Send order return notification to shop
        try {
          await sendShopNotification.sendReturnRequest(
            shopId: shopId,
            orderId: orderId,
          );
        } catch (_) {}
      }
    }
    // Send order return notification to admin
    try {
      await sendAdminNotification.sendOrderReturn(
        orderId: orderId,
        returnStatus: 'return_requested',
      );
    } catch (_) {}
  }
}
