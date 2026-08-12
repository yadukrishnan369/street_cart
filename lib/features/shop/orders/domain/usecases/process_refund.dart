import 'package:street_cart/features/shop/orders/domain/repositories/i_shop_orders_repository.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/get_customer_order_details.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/send_customer_notification.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/send_admin_notification.dart';

class ProcessRefund {
  final IShopOrdersRepository repository;
  final GetCustomerOrderDetails getOrderDetails;
  final SendCustomerNotification sendCustomerNotification;
  final SendAdminNotification sendAdminNotification;

  ProcessRefund({
    required this.repository,
    required this.getOrderDetails,
    required this.sendCustomerNotification,
    required this.sendAdminNotification,
  });

  Future<void> call(
    String orderId,
    double refundAmount,
    String refundStatus,
  ) async {
    final order = await getOrderDetails(orderId);

    await repository.processRefund(orderId, refundAmount, refundStatus);

    if (order != null) {
      // Send refund notification to customer
      try {
        await sendCustomerNotification.sendRefundProcessed(
          customerId: order.customerId,
          orderId: orderId,
          refundAmount: refundAmount,
        );
      } catch (_) {}
    }
  }
}
