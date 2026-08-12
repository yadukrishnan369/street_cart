import 'package:street_cart/features/customer/notification/data/datasources/i_customer_notification_datasource.dart';
import 'package:street_cart/features/customer/notification/data/models/customer_notification_model.dart';
import 'package:street_cart/features/customer/notification/domain/repositories/i_customer_notifications_repository.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';

class CustomerNotificationsRepositoryImpl
    implements ICustomerNotificationsRepository {
  final ICustomerNotificationDataSource _datasource;
  final INetworkInfo _networkInfo;

  CustomerNotificationsRepositoryImpl({
    required ICustomerNotificationDataSource datasource,
    required INetworkInfo networkInfo,
  }) : _datasource = datasource,
       _networkInfo = networkInfo;

  @override
  Future<OrderModel?> getOrderById(String orderId) {
    return _datasource.getOrderById(orderId);
  }

  @override
  Future<({ProductModel product, ShopProfileModel shop})?>
  getProductWithShopById(String productId) {
    return _datasource.getProductWithShopById(productId);
  }

  @override
  Stream<List<CustomerNotificationModel>> watchNotifications(
    String userId,
  ) async* {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    yield* _datasource.watchNotifications(userId);
  }

  @override
  Future<void> markAsRead(String userId, String notificationId) {
    return _datasource.markAsRead(userId, notificationId);
  }

  @override
  Future<void> markAllAsRead(String userId) {
    return _datasource.markAllAsRead(userId);
  }

  @override
  Future<void> sendOrderStatusNotification({
    required String customerId,
    required String orderId,
    required String status,
  }) {
    return _datasource.sendOrderStatusNotification(
      customerId: customerId,
      orderId: orderId,
      status: status,
    );
  }

  @override
  Future<void> sendReturnStatusNotification({
    required String customerId,
    required String orderId,
    required String returnStatus,
  }) {
    return _datasource.sendReturnStatusNotification(
      customerId: customerId,
      orderId: orderId,
      returnStatus: returnStatus,
    );
  }

  @override
  Future<void> sendRefundProcessedNotification({
    required String customerId,
    required String orderId,
    required double refundAmount,
  }) {
    return _datasource.sendRefundProcessedNotification(
      customerId: customerId,
      orderId: orderId,
      refundAmount: refundAmount,
    );
  }

  @override
  Future<void> sendWishlistPriceDropNotification({
    required String customerId,
    required String productId,
    required String productName,
    required int percentOff,
  }) {
    return _datasource.sendWishlistPriceDropNotification(
      customerId: customerId,
      productId: productId,
      productName: productName,
      percentOff: percentOff,
    );
  }

  @override
  Future<void> sendWishlistRestockNotification({
    required String customerId,
    required String productId,
    required String productName,
  }) {
    return _datasource.sendWishlistRestockNotification(
      customerId: customerId,
      productId: productId,
      productName: productName,
    );
  }

  @override
  Future<void> notifyWishlistedCustomers({
    required String productId,
    required String productName,
    required bool isPriceDrop,
    int percentOff = 0,
  }) {
    return _datasource.notifyWishlistedCustomers(
      productId: productId,
      productName: productName,
      isPriceDrop: isPriceDrop,
      percentOff: percentOff,
    );
  }

  @override
  Future<void> notifyCartCustomers({
    required String productId,
    required String productName,
    required int percentOff,
  }) {
    return _datasource.notifyCartCustomers(
      productId: productId,
      productName: productName,
      percentOff: percentOff,
    );
  }
}
