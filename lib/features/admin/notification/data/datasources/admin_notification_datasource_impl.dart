import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/services/notification_write_service.dart';
import 'package:street_cart/features/admin/notification/data/models/admin_notification_model.dart';
import 'i_admin_notification_datasource.dart';

class AdminNotificationDataSourceImpl implements IAdminNotificationDataSource {
  final FirebaseFirestore _firestore;

  AdminNotificationDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Send New Shop Registered Notification
  @override
  Future<void> sendNewShopRegisteredNotification({
    required String shopId,
    required String shopName,
  }) async {
    final shortId = shopId.length > 6
        ? shopId.substring(0, 6).toUpperCase()
        : shopId;
    await NotificationWriteService.notifyAllAdmins(
      title: 'New Shop Registered! 🏪',
      body:
          "'$shopName' ($shortId) has registered and is waiting to set up their profile.",
      type: 'shop_registration',
      relatedId: shopId,
    );
  }

  // Send Shop Resubmitted Notification
  @override
  Future<void> sendShopResubmittedNotification({
    required String shopId,
    required String shopName,
  }) async {
    final shortId = shopId.length > 6
        ? shopId.substring(0, 6).toUpperCase()
        : shopId;
    await NotificationWriteService.notifyAllAdmins(
      title: 'Shop Resubmitted Details 🔄',
      body:
          "'$shopName' ($shortId) has resubmitted their registration details for review.",
      type: 'shop_registration',
      relatedId: shopId,
    );
  }

  // Send Shop Profile Completed Notification
  @override
  Future<void> sendShopProfileCompletedNotification({
    required String shopId,
    required String shopName,
  }) async {
    final shortId = shopId.length > 6
        ? shopId.substring(0, 6).toUpperCase()
        : shopId;
    await NotificationWriteService.notifyAllAdmins(
      title: 'Shop Profile Ready 🏪',
      body:
          "'$shopName' ($shortId) has completed their profile setup and is waiting for your review.",
      type: 'shop_registration',
      relatedId: shopId,
    );
  }

  // Send New Order Notification
  @override
  Future<void> sendNewOrderNotification({
    required String orderId,
    required double amount,
    String? status,
  }) async {
    final shortId = orderId.length > 6
        ? orderId.substring(0, 6).toUpperCase()
        : orderId;
    String title = 'New Order Placed! 🛒';
    String body =
        'Order #$shortId has been placed successfully for ₹${amount.toStringAsFixed(2)}.';

    if (status != null) {
      final s = status.toLowerCase();
      if (s == 'confirmed') {
        title = 'Order Confirmed! ✅';
        body = 'Order #$shortId has been confirmed by the vendor.';
      } else if (s == 'shipped') {
        title = 'Order Shipped! 📦';
        body = 'Order #$shortId has been shipped and is on the way.';
      } else if (s == 'delivered') {
        title = 'Order Delivered! 🎉';
        body = 'Order #$shortId has been successfully delivered.';
      } else if (s == 'refunded') {
        title = 'Order Refunded 💸';
        body =
            'Refund of ₹${amount.toStringAsFixed(2)} has been processed for Order #$shortId.';
      }
    }

    await NotificationWriteService.notifyAllAdmins(
      title: title,
      body: body,
      type: 'order',
      relatedId: orderId,
    );
  }

  // Send Order Cancelled Notification
  @override
  Future<void> sendOrderCancelledNotification({required String orderId}) async {
    final shortId = orderId.length > 6
        ? orderId.substring(0, 6).toUpperCase()
        : orderId;
    await NotificationWriteService.notifyAllAdmins(
      title: 'Order Cancelled 🚫',
      body: 'Order #$shortId has been cancelled.',
      type: 'order',
      relatedId: orderId,
    );
  }

  // Send Order Return Notification
  @override
  Future<void> sendOrderReturnNotification({
    required String orderId,
    String? returnStatus,
  }) async {
    final shortId = orderId.length > 6
        ? orderId.substring(0, 6).toUpperCase()
        : orderId;
    String title = 'Return Requested 🔄';
    String body = 'A return request has been submitted for Order #$shortId.';

    if (returnStatus != null) {
      final rs = returnStatus.toLowerCase();
      if (rs == 'returned' ||
          rs == 'picked' ||
          rs == 'picked_up' ||
          rs == 'received' ||
          rs == 'return_picked') {
        title = 'Item Returned 🔄';
        body =
            'Returned item for Order #$shortId has been received by the vendor.';
      }
    }

    await NotificationWriteService.notifyAllAdmins(
      title: title,
      body: body,
      type: 'order',
      relatedId: orderId,
    );
  }

  // Watch Notifications
  @override
  Stream<List<AdminNotificationModel>> watchNotifications(String adminId) {
    return _firestore
        .collection('admins')
        .doc(adminId)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return AdminNotificationModel.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  // Mark As Read
  @override
  Future<void> markAsRead(String adminId, String notificationId) async {
    await _firestore
        .collection('admins')
        .doc(adminId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  // Mark All As Read
  @override
  Future<void> markAllAsRead(String adminId) async {
    final query = await _firestore
        .collection('admins')
        .doc(adminId)
        .collection('notifications')
        .get();

    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
