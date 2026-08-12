import 'package:street_cart/features/admin/notification/data/models/admin_notification_model.dart';

abstract class IAdminNotificationsRepository {
  Stream<List<AdminNotificationModel>> watchNotifications(String adminId);
  Future<void> markAsRead(String adminId, String notificationId);
  Future<void> markAllAsRead(String adminId);

  Future<void> sendNewShopRegisteredNotification({
    required String shopId,
    required String shopName,
  });

  Future<void> sendShopResubmittedNotification({
    required String shopId,
    required String shopName,
  });

  Future<void> sendShopProfileCompletedNotification({
    required String shopId,
    required String shopName,
  });

  Future<void> sendNewOrderNotification({
    required String orderId,
    required double amount,
    String? status,
  });

  Future<void> sendOrderCancelledNotification({required String orderId});

  Future<void> sendOrderReturnNotification({
    required String orderId,
    String? returnStatus,
  });
}
