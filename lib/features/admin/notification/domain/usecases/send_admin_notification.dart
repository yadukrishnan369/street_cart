import 'package:street_cart/features/admin/notification/domain/repositories/i_admin_notifications_repository.dart';

class SendAdminNotification {
  final IAdminNotificationsRepository repository;

  SendAdminNotification(this.repository);

  Future<void> sendNewShopRegistered({
    required String shopId,
    required String shopName,
  }) {
    return repository.sendNewShopRegisteredNotification(
      shopId: shopId,
      shopName: shopName,
    );
  }

  Future<void> sendShopResubmitted({
    required String shopId,
    required String shopName,
  }) {
    return repository.sendShopResubmittedNotification(
      shopId: shopId,
      shopName: shopName,
    );
  }

  Future<void> sendShopProfileCompleted({
    required String shopId,
    required String shopName,
  }) {
    return repository.sendShopProfileCompletedNotification(
      shopId: shopId,
      shopName: shopName,
    );
  }

  Future<void> sendNewOrder({
    required String orderId,
    required double amount,
    String? status,
  }) {
    return repository.sendNewOrderNotification(
      orderId: orderId,
      amount: amount,
      status: status,
    );
  }

  Future<void> sendOrderCancelled({required String orderId}) {
    return repository.sendOrderCancelledNotification(orderId: orderId);
  }

  Future<void> sendOrderReturn({
    required String orderId,
    String? returnStatus,
  }) {
    return repository.sendOrderReturnNotification(
      orderId: orderId,
      returnStatus: returnStatus,
    );
  }
}
