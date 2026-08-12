import 'package:street_cart/features/shop/orders/domain/repositories/i_shop_orders_repository.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/get_customer_order_details.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/send_customer_notification.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/send_admin_notification.dart';

class UpdateShopOrderReturnStatus {
  final IShopOrdersRepository repository;
  final GetCustomerOrderDetails getOrderDetails;
  final SendCustomerNotification sendCustomerNotification;
  final SendAdminNotification sendAdminNotification;

  UpdateShopOrderReturnStatus({
    required this.repository,
    required this.getOrderDetails,
    required this.sendCustomerNotification,
    required this.sendAdminNotification,
  });

  Future<void> call(
    String orderId,
    String returnStatus, {
    bool refundViaHand = false,
    double refundAmount = 0.0,
  }) async {
    final order = await getOrderDetails(orderId);

    await repository.updateReturnStatus(
      orderId,
      returnStatus,
      refundViaHand: refundViaHand,
      refundAmount: refundAmount,
    );

    if (order != null) {
      // Send return order status to customer
      try {
        await sendCustomerNotification.sendReturnStatus(
          customerId: order.customerId,
          orderId: orderId,
          returnStatus: returnStatus,
        );
      } catch (_) {}

      try {
        final statusLower = returnStatus.toLowerCase();
        if (statusLower == 'returned' ||
            statusLower == 'picked' ||
            statusLower == 'picked_up' ||
            statusLower == 'received' ||
            statusLower == 'return_picked') {
          await sendAdminNotification.sendOrderReturn(
            orderId: orderId,
            returnStatus: returnStatus,
          );
        }
      } catch (_) {}
    }
  }
}
