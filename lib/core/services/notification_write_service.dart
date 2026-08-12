import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationWriteService {
  NotificationWriteService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a custom alert notification to a specific shop profile database collection
  static Future<void> sendToShop({
    required String shopId,
    required String title,
    required String body,
    required String type,
    String? relatedId,
  }) async {
    await _write(
      collection: 'shops',
      userId: shopId,
      title: title,
      body: body,
      type: type,
      relatedId: relatedId,
    );
  }

  // Send a custom alert notification to a specific customer profile database collection
  static Future<void> sendToCustomer({
    required String customerId,
    required String title,
    required String body,
    required String type,
    String? relatedId,
  }) async {
    await _write(
      collection: 'customers',
      userId: customerId,
      title: title,
      body: body,
      type: type,
      relatedId: relatedId,
    );
  }

  // Send a custom alert notification to a specific admin configuration database collection
  static Future<void> sendToAdmin({
    required String adminId,
    required String title,
    required String body,
    required String type,
    String? relatedId,
  }) async {
    bool allowed = true;
    try {
      // Validate preferences in the administrator settings document before writing alerts
      final doc = await _firestore.collection('admins').doc(adminId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final regEnabled = data['registrationAlertsEnabled'] ?? true;
        final orderEnabled = data['orderAlertsEnabled'] ?? true;

        // Skip writing notification record if that specific channel toggle is off
        if (type == 'shop_registration' && !regEnabled) allowed = false;
        if (type == 'order' && !orderEnabled) allowed = false;
      }
    } catch (_) {
      allowed = true;
    }

    if (!allowed) return;

    await _write(
      collection: 'admins',
      userId: adminId,
      title: title,
      body: body,
      type: type,
      relatedId: relatedId,
    );
  }

  // Iterates and writes notifications to all registered system administrator accounts in parallel
  static Future<void> notifyAllAdmins({
    required String title,
    required String body,
    required String type,
    String? relatedId,
  }) async {
    try {
      final adminsSnap = await _firestore.collection('admins').get();
      await Future.wait(
        adminsSnap.docs.map(
          (doc) => sendToAdmin(
            adminId: doc.id,
            title: title,
            body: body,
            type: type,
            relatedId: relatedId,
          ),
        ),
      );
    } catch (_) {}
  }

  // Query wishlist collections and push stock/price notifications to customers holding this product
  static Future<void> notifyWishlistedCustomers({
    required String productId,
    required String title,
    required String body,
    required String type,
  }) async {
    try {
      final customersSnap = await _firestore.collection('customers').get();
      await Future.wait(
        customersSnap.docs.map((doc) async {
          // Check if product exists in this customer's wishlist subcollection
          final wishlistDoc = await _firestore
              .collection('customers')
              .doc(doc.id)
              .collection('wishlist')
              .doc(productId)
              .get();
          if (wishlistDoc.exists) {
            await sendToCustomer(
              customerId: doc.id,
              title: title,
              body: body,
              type: type,
              relatedId: productId,
            );
          }
        }),
      );
    } catch (_) {}
  }

  // Query active shopping carts and notify customers holding this product in their basket
  static Future<void> notifyCartCustomers({
    required String productId,
    required String title,
    required String body,
    required String type,
  }) async {
    try {
      final customersSnap = await _firestore.collection('customers').get();
      await Future.wait(
        customersSnap.docs.map((doc) async {
          // Query the user's cart collection for records containing this specific product ID
          final cartSnap = await _firestore
              .collection('customers')
              .doc(doc.id)
              .collection('cart')
              .where('product_id', isEqualTo: productId)
              .limit(1)
              .get();
          if (cartSnap.docs.isNotEmpty) {
            await sendToCustomer(
              customerId: doc.id,
              title: title,
              body: body,
              type: type,
              relatedId: productId,
            );
          }
        }),
      );
    } catch (_) {}
  }

  // Base private helper to write notification records into target subcollections
  static Future<void> _write({
    required String collection,
    required String userId,
    required String title,
    required String body,
    required String type,
    String? relatedId,
  }) async {
    try {
      // Build document schema parameters for notification entry
      final Map<String, dynamic> data = {
        'title': title,
        'body': body,
        'type': type,
        'is_read': false,
        'created_at': FieldValue.serverTimestamp(),
      };
      if (relatedId != null) data['related_id'] = relatedId;

      // Add a new document to the user's notifications subcollection in Firestore
      await _firestore
          .collection(collection)
          .doc(userId)
          .collection('notifications')
          .add(data);
    } catch (_) {}
  }
}
