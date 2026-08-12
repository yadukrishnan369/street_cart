import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/services/notification_write_service.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/notification/data/models/shop_notification_model.dart';
import 'i_shop_notification_datasource.dart';

class ShopNotificationDataSourceImpl implements IShopNotificationDataSource {
  final FirebaseFirestore _firestore;

  ShopNotificationDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Send New Order Notification
  @override
  Future<void> sendNewOrderNotification({
    required String shopId,
    required String orderId,
    required int itemCount,
  }) async {
    await NotificationWriteService.sendToShop(
      shopId: shopId,
      title: 'New Order Received! 🛍️',
      body:
          'You have a new order with $itemCount item${itemCount == 1 ? '' : 's'} waiting for your confirmation.',
      type: 'new_order',
      relatedId: orderId,
    );
  }

  // Send Order Cancelled By Customer Notification
  @override
  Future<void> sendOrderCancelledByCustomerNotification({
    required String shopId,
    required String orderId,
  }) async {
    final suffix = orderId.length >= 5
        ? orderId.substring(orderId.length - 5).toUpperCase()
        : orderId.toUpperCase();
    await NotificationWriteService.sendToShop(
      shopId: shopId,
      title: 'Order Cancelled 🛑',
      body: 'Order #$suffix has been cancelled by the customer.',
      type: 'order_status',
      relatedId: orderId,
    );
  }

  // Send Return Request Notification
  @override
  Future<void> sendReturnRequestNotification({
    required String shopId,
    required String orderId,
  }) async {
    final suffix = orderId.length >= 5
        ? orderId.substring(orderId.length - 5).toUpperCase()
        : orderId.toUpperCase();
    await NotificationWriteService.sendToShop(
      shopId: shopId,
      title: 'Return Request! 🔄',
      body: 'A return request has been submitted for Order #$suffix.',
      type: 'order_status',
      relatedId: orderId,
    );
  }

  // Send Review Notification
  @override
  Future<void> sendReviewNotification({
    required String shopId,
    required String productId,
    required String productName,
    required int rating,
  }) async {
    await NotificationWriteService.sendToShop(
      shopId: shopId,
      title: 'New Product Review! ⭐',
      body: "Customer left a $rating-star review on your '$productName'.",
      type: 'product_review',
      relatedId: productId,
    );
  }

  // Send Approval Status Notification
  @override
  Future<void> sendApprovalStatusNotification({
    required String shopId,
    required String shopName,
    required bool approved,
    String? rejectionReason,
  }) async {
    if (approved) {
      await NotificationWriteService.sendToShop(
        shopId: shopId,
        title: 'Shop Approved! 🎉',
        body:
            "Congratulations! Your shop '$shopName' has been approved. You can now start adding products.",
        type: 'shop_status',
        relatedId: shopId,
      );
    } else {
      await NotificationWriteService.sendToShop(
        shopId: shopId,
        title: 'Registration Rejected ❌',
        body:
            'Your shop registration was rejected. Reason: ${rejectionReason ?? ''}',
        type: 'shop_status',
        relatedId: shopId,
      );
    }
  }

  // Send Commission Update Notification
  @override
  Future<void> sendCommissionUpdateNotification({
    required String shopId,
    required double percentage,
  }) async {
    await NotificationWriteService.sendToShop(
      shopId: shopId,
      title: 'Platform Commission Updated! 📢',
      body:
          'The platform commission rate has been adjusted to ${percentage.toStringAsFixed(1)}%.',
      type: 'commission_update',
    );
  }

  // Get Order By Id
  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await _firestore.collection('orders').doc(orderId).get();
    if (doc.exists && doc.data() != null) {
      return OrderModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Watch Notifications
  @override
  Stream<List<ShopNotificationModel>> watchNotifications(String shopId) {
    return _firestore
        .collection('shops')
        .doc(shopId)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ShopNotificationModel.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  // Mark As Read
  @override
  Future<void> markAsRead(String shopId, String notificationId) async {
    await _firestore
        .collection('shops')
        .doc(shopId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  // Mark All As Read
  @override
  Future<void> markAllAsRead(String shopId) async {
    final query = await _firestore
        .collection('shops')
        .doc(shopId)
        .collection('notifications')
        .get();
    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // Delete Notification
  @override
  Future<void> deleteNotification(String shopId, String notificationId) async {
    await _firestore
        .collection('shops')
        .doc(shopId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }
}
