import 'package:street_cart/features/admin/notification/data/datasources/i_admin_notification_datasource.dart';
import 'package:street_cart/features/admin/notification/data/models/admin_notification_model.dart';
import 'package:street_cart/features/admin/notification/domain/repositories/i_admin_notifications_repository.dart';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';

class AdminNotificationsRepositoryImpl
    implements IAdminNotificationsRepository {
  final IAdminNotificationDataSource _datasource;
  final INetworkInfo _networkInfo;

  AdminNotificationsRepositoryImpl({
    required IAdminNotificationDataSource datasource,
    required INetworkInfo networkInfo,
  }) : _datasource = datasource,
       _networkInfo = networkInfo;

  @override
  Stream<List<AdminNotificationModel>> watchNotifications(
    String adminId,
  ) async* {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    yield* _datasource.watchNotifications(adminId);
  }

  @override
  Future<void> markAsRead(String adminId, String notificationId) {
    return _datasource.markAsRead(adminId, notificationId);
  }

  @override
  Future<void> markAllAsRead(String adminId) {
    return _datasource.markAllAsRead(adminId);
  }

  @override
  Future<void> sendNewShopRegisteredNotification({
    required String shopId,
    required String shopName,
  }) {
    return _datasource.sendNewShopRegisteredNotification(
      shopId: shopId,
      shopName: shopName,
    );
  }

  @override
  Future<void> sendShopResubmittedNotification({
    required String shopId,
    required String shopName,
  }) {
    return _datasource.sendShopResubmittedNotification(
      shopId: shopId,
      shopName: shopName,
    );
  }

  @override
  Future<void> sendShopProfileCompletedNotification({
    required String shopId,
    required String shopName,
  }) {
    return _datasource.sendShopProfileCompletedNotification(
      shopId: shopId,
      shopName: shopName,
    );
  }

  @override
  Future<void> sendNewOrderNotification({
    required String orderId,
    required double amount,
    String? status,
  }) {
    return _datasource.sendNewOrderNotification(
      orderId: orderId,
      amount: amount,
      status: status,
    );
  }

  @override
  Future<void> sendOrderCancelledNotification({required String orderId}) {
    return _datasource.sendOrderCancelledNotification(orderId: orderId);
  }

  @override
  Future<void> sendOrderReturnNotification({
    required String orderId,
    String? returnStatus,
  }) {
    return _datasource.sendOrderReturnNotification(
      orderId: orderId,
      returnStatus: returnStatus,
    );
  }
}
