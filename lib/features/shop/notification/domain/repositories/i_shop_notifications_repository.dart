import 'package:street_cart/features/shop/notification/data/models/shop_notification_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

abstract class IShopNotificationsRepository {
  Future<OrderModel?> getOrderById(String orderId);
  Stream<List<ShopNotificationModel>> watchNotifications(String shopId);
  Future<void> markAsRead(String shopId, String notificationId);
  Future<void> markAllAsRead(String shopId);
  Future<void> deleteNotification(String shopId, String notificationId);

  Future<void> sendNewOrderNotification({
    required String shopId,
    required String orderId,
    required int itemCount,
  });

  Future<void> sendOrderCancelledByCustomerNotification({
    required String shopId,
    required String orderId,
  });

  Future<void> sendReturnRequestNotification({
    required String shopId,
    required String orderId,
  });

  Future<void> sendReviewNotification({
    required String shopId,
    required String productId,
    required String productName,
    required int rating,
  });

  Future<void> sendApprovalStatusNotification({
    required String shopId,
    required String shopName,
    required bool approved,
    String? rejectionReason,
  });

  Future<void> sendCommissionUpdateNotification({
    required String shopId,
    required double percentage,
  });
}
