import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/services/notification_write_service.dart';
import 'package:street_cart/features/customer/notification/data/models/customer_notification_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'i_customer_notification_datasource.dart';

class CustomerNotificationDataSourceImpl
    implements ICustomerNotificationDataSource {
  final FirebaseFirestore _firestore;

  CustomerNotificationDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Status messages
  static const Map<String, Map<String, String>> _statusMessages = {
    'placed': {
      'title': 'Order Placed! 🎉',
      'body': 'Your order has been placed and is awaiting confirmation.',
    },
    'confirmed': {
      'title': 'Order Confirmed ✅',
      'body': 'Great news! Your order has been confirmed by the shop.',
    },
    'processing': {
      'title': 'Order Processing 🔧',
      'body': 'Your order is currently being prepared.',
    },
    'shipped': {
      'title': 'Order Shipped 🚚',
      'body': 'Your order is on its way! Track your delivery.',
    },
    'out_for_delivery': {
      'title': 'Out for Delivery 📦',
      'body': 'Your order is out for delivery. Expect it soon!',
    },
    'delivered': {
      'title': 'Order Delivered 🎁',
      'body':
          'Your order has been delivered successfully. Enjoy your purchase!',
    },
    'cancelled': {
      'title': 'Order Cancelled',
      'body':
          'Your order has been cancelled. If you have questions, please contact support.',
    },
  };
  // Send Order Status Notification
  @override
  Future<void> sendOrderStatusNotification({
    required String customerId,
    required String orderId,
    required String status,
  }) async {
    final msg = _statusMessages[status];
    if (msg == null) return;
    await NotificationWriteService.sendToCustomer(
      customerId: customerId,
      title: msg['title']!,
      body: msg['body']!,
      type: 'order_status',
      relatedId: orderId,
    );
  }

  // Send Return Status Notification
  @override
  Future<void> sendReturnStatusNotification({
    required String customerId,
    required String orderId,
    required String returnStatus,
  }) async {
    String title = 'Return Status Updated 🔄';
    String body = 'Your return status has been updated to: $returnStatus.';
    if (returnStatus == 'return_confirmed') {
      title = 'Return Request Approved! ✅';
      body = 'Your return request has been approved by the merchant.';
    } else if (returnStatus == 'return_picked') {
      title = 'Return Item Picked Up! 📦';
      body = 'The returned item has been successfully picked up.';
    }
    await NotificationWriteService.sendToCustomer(
      customerId: customerId,
      title: title,
      body: body,
      type: 'order_status',
      relatedId: orderId,
    );
  }

  // Send Refund Processed Notification
  @override
  Future<void> sendRefundProcessedNotification({
    required String customerId,
    required String orderId,
    required double refundAmount,
  }) async {
    await NotificationWriteService.sendToCustomer(
      customerId: customerId,
      title: 'Refund Processed! 💳',
      body:
          'A refund of ₹${refundAmount.toStringAsFixed(0)} has been initiated for your order.',
      type: 'order_status',
      relatedId: orderId,
    );
  }

  // Send Wishlist Price Drop Notification
  @override
  Future<void> sendWishlistPriceDropNotification({
    required String customerId,
    required String productId,
    required String productName,
    required int percentOff,
  }) async {
    await NotificationWriteService.sendToCustomer(
      customerId: customerId,
      title: 'Price Drop Alert! 📉',
      body: "'$productName' in your wishlist is now $percentOff% off!",
      type: 'wishlist_alert',
      relatedId: productId,
    );
  }

  // Send Wishlist Restock Notification
  @override
  Future<void> sendWishlistRestockNotification({
    required String customerId,
    required String productId,
    required String productName,
  }) async {
    await NotificationWriteService.sendToCustomer(
      customerId: customerId,
      title: 'Back in Stock! 🛒',
      body: "'$productName' is available now. Buy before it sells out!",
      type: 'wishlist_alert',
      relatedId: productId,
    );
  }

  // Notify Wishlisted Customers
  @override
  Future<void> notifyWishlistedCustomers({
    required String productId,
    required String productName,
    required bool isPriceDrop,
    int percentOff = 0,
  }) async {
    await NotificationWriteService.notifyWishlistedCustomers(
      productId: productId,
      title: isPriceDrop ? 'Price Drop Alert! 📉' : 'Back in Stock! 🛒',
      body: isPriceDrop
          ? "'$productName' in your wishlist is now $percentOff% off!"
          : "'$productName' is available now. Buy before it sells out!",
      type: 'wishlist_alert',
    );
  }

  // Notify Cart Customers
  @override
  Future<void> notifyCartCustomers({
    required String productId,
    required String productName,
    required int percentOff,
  }) async {
    await NotificationWriteService.notifyCartCustomers(
      productId: productId,
      title: percentOff > 0
          ? 'Price Drop on Your Cart Item! 🛒'
          : 'Cart Item Back in Stock! 🛒',
      body: percentOff > 0
          ? "'$productName' in your cart is now $percentOff% cheaper! Update your cart."
          : "'$productName' in your cart is back in stock! Order before it sells out.",
      type: 'cart_price_drop',
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

  // Get Product With Shop By Id
  @override
  Future<({ProductModel product, ShopProfileModel shop})?>
  getProductWithShopById(String productId) async {
    final productDoc = await _firestore
        .collection('products')
        .doc(productId)
        .get();
    if (!productDoc.exists || productDoc.data() == null) return null;
    final product = ProductModel.fromMap(productDoc.data()!, productDoc.id);
    final shopDoc = await _firestore
        .collection('shops')
        .doc(product.shopId)
        .get();
    if (!shopDoc.exists || shopDoc.data() == null) return null;
    final shop = ShopProfileModel.fromMap(shopDoc.data()!, shopDoc.id);
    return (product: product, shop: shop);
  }

  // Watch Notifications
  @override
  Stream<List<CustomerNotificationModel>> watchNotifications(String userId) {
    return _firestore
        .collection('customers')
        .doc(userId)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => CustomerNotificationModel.fromMap(doc.id, doc.data()),
              )
              .toList();
        });
  }

  // Mark As Read
  @override
  Future<void> markAsRead(String userId, String notificationId) async {
    await _firestore
        .collection('customers')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  // Mark All As Read
  @override
  Future<void> markAllAsRead(String userId) async {
    final query = await _firestore
        .collection('customers')
        .doc(userId)
        .collection('notifications')
        .get();
    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
