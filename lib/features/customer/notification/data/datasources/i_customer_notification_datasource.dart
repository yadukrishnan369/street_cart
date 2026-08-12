import 'package:street_cart/features/customer/notification/data/models/customer_notification_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class ICustomerNotificationDataSource {
  Future<void> sendOrderStatusNotification({
    required String customerId,
    required String orderId,
    required String status,
  });

  Future<void> sendReturnStatusNotification({
    required String customerId,
    required String orderId,
    required String returnStatus,
  });

  Future<void> sendRefundProcessedNotification({
    required String customerId,
    required String orderId,
    required double refundAmount,
  });

  Future<void> sendWishlistPriceDropNotification({
    required String customerId,
    required String productId,
    required String productName,
    required int percentOff,
  });

  Future<void> sendWishlistRestockNotification({
    required String customerId,
    required String productId,
    required String productName,
  });

  Future<void> notifyWishlistedCustomers({
    required String productId,
    required String productName,
    required bool isPriceDrop,
    int percentOff = 0,
  });

  Future<void> notifyCartCustomers({
    required String productId,
    required String productName,
    required int percentOff,
  });

  Future<OrderModel?> getOrderById(String orderId);
  Future<({ProductModel product, ShopProfileModel shop})?>
  getProductWithShopById(String productId);
  Stream<List<CustomerNotificationModel>> watchNotifications(String userId);
  Future<void> markAsRead(String userId, String notificationId);
  Future<void> markAllAsRead(String userId);
}
