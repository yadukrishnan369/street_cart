import 'package:street_cart/features/shop/orders/domain/repositories/i_shop_orders_repository.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/get_customer_order_details.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/send_customer_notification.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/send_admin_notification.dart';

class UpdateShopOrderStatus {
  final IShopOrdersRepository repository;
  final GetCustomerOrderDetails getOrderDetails;
  final SendCustomerNotification sendCustomerNotification;
  final SendAdminNotification sendAdminNotification;

  UpdateShopOrderStatus({
    required this.repository,
    required this.getOrderDetails,
    required this.sendCustomerNotification,
    required this.sendAdminNotification,
  });

  Future<void> call(String orderId, String newStatus) async {
    final order = await getOrderDetails(orderId);

    await repository.updateOrderStatus(orderId, newStatus);

    if (order != null) {
      // Send order status notification to customer
      try {
        await sendCustomerNotification.sendOrderStatus(
          customerId: order.customerId,
          orderId: orderId,
          status: newStatus.toLowerCase(),
        );
      } catch (_) {}
      // Send delivery order status notification to customer
      try {
        if (newStatus.toLowerCase() == 'delivered') {
          await sendAdminNotification.sendNewOrder(
            orderId: orderId,
            amount: order.totalAmount,
            status: newStatus,
          );
        }
      } catch (_) {}
    }
  }
}
