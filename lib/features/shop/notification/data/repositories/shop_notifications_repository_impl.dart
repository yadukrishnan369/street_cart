import 'package:street_cart/features/shop/notification/data/datasources/i_shop_notification_datasource.dart';
import 'package:street_cart/features/shop/notification/data/models/shop_notification_model.dart';
import 'package:street_cart/features/shop/notification/domain/repositories/i_shop_notifications_repository.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';

class ShopNotificationsRepositoryImpl implements IShopNotificationsRepository {
  final IShopNotificationDataSource _datasource;
  final INetworkInfo _networkInfo;

  ShopNotificationsRepositoryImpl({
    required IShopNotificationDataSource datasource,
    required INetworkInfo networkInfo,
  }) : _datasource = datasource,
       _networkInfo = networkInfo;

  @override
  Future<OrderModel?> getOrderById(String orderId) {
    return _datasource.getOrderById(orderId);
  }

  @override
  Stream<List<ShopNotificationModel>> watchNotifications(String shopId) async* {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    yield* _datasource.watchNotifications(shopId);
  }

  @override
  Future<void> markAsRead(String shopId, String notificationId) {
    return _datasource.markAsRead(shopId, notificationId);
  }

  @override
  Future<void> markAllAsRead(String shopId) {
    return _datasource.markAllAsRead(shopId);
  }

  @override
  Future<void> deleteNotification(String shopId, String notificationId) {
    return _datasource.deleteNotification(shopId, notificationId);
  }

  @override
  Future<void> sendNewOrderNotification({
    required String shopId,
    required String orderId,
    required int itemCount,
  }) {
    return _datasource.sendNewOrderNotification(
      shopId: shopId,
      orderId: orderId,
      itemCount: itemCount,
    );
  }

  @override
  Future<void> sendOrderCancelledByCustomerNotification({
    required String shopId,
    required String orderId,
  }) {
    return _datasource.sendOrderCancelledByCustomerNotification(
      shopId: shopId,
      orderId: orderId,
    );
  }

  @override
  Future<void> sendReturnRequestNotification({
    required String shopId,
    required String orderId,
  }) {
    return _datasource.sendReturnRequestNotification(
      shopId: shopId,
      orderId: orderId,
    );
  }

  @override
  Future<void> sendReviewNotification({
    required String shopId,
    required String productId,
    required String productName,
    required int rating,
  }) {
    return _datasource.sendReviewNotification(
      shopId: shopId,
      productId: productId,
      productName: productName,
      rating: rating,
    );
  }

  @override
  Future<void> sendApprovalStatusNotification({
    required String shopId,
    required String shopName,
    required bool approved,
    String? rejectionReason,
  }) {
    return _datasource.sendApprovalStatusNotification(
      shopId: shopId,
      shopName: shopName,
      approved: approved,
      rejectionReason: rejectionReason,
    );
  }

  @override
  Future<void> sendCommissionUpdateNotification({
    required String shopId,
    required double percentage,
  }) {
    return _datasource.sendCommissionUpdateNotification(
      shopId: shopId,
      percentage: percentage,
    );
  }
}
