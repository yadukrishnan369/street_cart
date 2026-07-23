import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/orders/data/datasources/i_orders_remote_datasource.dart';
import 'package:street_cart/core/utils/delivery_validator.dart';

class OrdersRemoteDataSourceImpl implements IOrdersRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final DeliveryValidator _deliveryValidator;

  OrdersRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required DeliveryValidator deliveryValidator,
  }) : _auth = auth,
       _firestore = firestore,
       _deliveryValidator = deliveryValidator;

  // Fetch Customer Orders
  @override
  Stream<List<OrderModel>> getCustomerOrders() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }

    return _firestore
        .collection('orders')
        .where('customer_id', isEqualTo: user.uid)
        .snapshots()
        .map((querySnapshot) {
          final orders = querySnapshot.docs.map((doc) {
            return OrderModel.fromMap(doc.data(), doc.id);
          }).toList();

          // Sort by createdAt descending order
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return orders;
        });
  }

  // Cancel Order
  @override
  Future<void> cancelOrder(String orderId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User is not logged in');

    // Fetch order to get item details for stock revert
    final orderDoc = await _firestore.collection('orders').doc(orderId).get();
    if (!orderDoc.exists) throw Exception('Order not found');

    final data = orderDoc.data()!;
    final items = (data['items'] as List<dynamic>? ?? []);

    // stock revert
    await _firestore.runTransaction((transaction) async {
      // fetch all product data
      final Map<String, DocumentSnapshot<Map<String, dynamic>>>
      productSnapshots = {};
      for (final item in items) {
        final productId = item['product_id'] as String? ?? '';
        if (productId.isNotEmpty && !productSnapshots.containsKey(productId)) {
          final ref = _firestore.collection('products').doc(productId);
          productSnapshots[productId] = await transaction.get(ref);
        }
      }

      // Mark order as cancelled
      transaction.update(_firestore.collection('orders').doc(orderId), {
        'status': 'cancelled',
      });

      // Revert stock for each item
      for (final item in items) {
        final productId = item['product_id'] as String? ?? '';
        final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
        final selectedColor = item['selected_color'] as String?;
        final selectedSize = item['selected_size'] as String?;

        if (productId.isEmpty || quantity <= 0) continue;

        final productDoc = productSnapshots[productId];
        if (productDoc == null || !productDoc.exists) continue;

        final productData = productDoc.data()!;
        final variantsRaw = productData['variants'] as List<dynamic>? ?? [];

        if (variantsRaw.isEmpty) {
          // If No variants, revert stockQuantity
          final currentStock =
              (productData['stockQuantity'] as num?)?.toInt() ?? 0;
          transaction.update(productDoc.reference, {
            'stockQuantity': currentStock + quantity,
          });
        } else {
          // If Variants exist, find matching color+size and revert that sizes stock
          final List<Map<String, dynamic>> variants = variantsRaw
              .map((v) => Map<String, dynamic>.from(v as Map))
              .toList();

          for (var i = 0; i < variants.length; i++) {
            final variant = variants[i];
            if (variant['color_name'] == selectedColor) {
              final sizes = Map<String, dynamic>.from(
                variant['sizes'] as Map? ?? {},
              );
              final currentSizeStock =
                  (sizes[selectedSize] as num?)?.toInt() ?? 0;
              sizes[selectedSize!] = currentSizeStock + quantity;
              variant['sizes'] = sizes;
              // Recalculate total_stock for this variant
              variant['total_stock'] = sizes.values.fold(
                0,
                (acc, qty) => acc + (qty as num).toInt(),
              );
              break;
            }
          }
          transaction.update(productDoc.reference, {'variants': variants});
        }
      }
    });
  }

  // Cancel Specif Order Item
  @override
  Future<void> cancelOrderItem(String orderId, String orderItemId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User is not logged in');

    // Fetch order to target item and check details for stock revert
    final orderDoc = await _firestore.collection('orders').doc(orderId).get();
    if (!orderDoc.exists) throw Exception('Order not found');

    final data = orderDoc.data()!;
    final itemsRaw = (data['items'] as List<dynamic>? ?? []);
    final items = itemsRaw
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();

    final itemIndex = items.indexWhere((item) => item['id'] == orderItemId);
    if (itemIndex == -1) throw Exception('Item not found in order');

    final itemToCancel = items[itemIndex];

    // Transaction for stock revert and order update
    await _firestore.runTransaction((transaction) async {
      final productId = itemToCancel['product_id'] as String? ?? '';
      if (productId.isEmpty) throw Exception('Product ID is missing');

      final productRef = _firestore.collection('products').doc(productId);
      final productSnap = await transaction.get(productRef);

      if (productSnap.exists) {
        final productData = productSnap.data()!;
        final quantity = (itemToCancel['quantity'] as num?)?.toInt() ?? 0;
        final selectedColor = itemToCancel['selected_color'] as String?;
        final selectedSize = itemToCancel['selected_size'] as String?;

        final variantsRaw = productData['variants'] as List<dynamic>? ?? [];

        if (variantsRaw.isEmpty) {
          final currentStock =
              (productData['stockQuantity'] as num?)?.toInt() ?? 0;
          transaction.update(productRef, {
            'stockQuantity': currentStock + quantity,
          });
        } else {
          final List<Map<String, dynamic>> variants = variantsRaw
              .map((v) => Map<String, dynamic>.from(v as Map))
              .toList();

          for (var i = 0; i < variants.length; i++) {
            final variant = variants[i];
            if (variant['color_name'] == selectedColor) {
              final sizes = Map<String, dynamic>.from(
                variant['sizes'] as Map? ?? {},
              );
              final currentSizeStock =
                  (sizes[selectedSize] as num?)?.toInt() ?? 0;
              sizes[selectedSize!] = currentSizeStock + quantity;
              variant['sizes'] = sizes;
              variant['total_stock'] = sizes.values.fold(
                0,
                (acc, qty) => acc + (qty as num).toInt(),
              );
              break;
            }
          }
          transaction.update(productRef, {'variants': variants});
        }
      }

      // If this is the only item in the order, cancel the entire order
      if (items.length == 1) {
        transaction.update(_firestore.collection('orders').doc(orderId), {
          'status': 'cancelled',
        });
      } else {
        // Remove the item and update order totals
        items.removeAt(itemIndex);
        final itemPrice = (itemToCancel['price'] as num).toDouble();
        final itemQty = (itemToCancel['quantity'] as num).toInt();
        final currentTotal = (data['total_amount'] as num).toDouble();
        final newTotal = currentTotal - (itemPrice * itemQty);

        transaction.update(_firestore.collection('orders').doc(orderId), {
          'items': items,
          'total_amount': newTotal,
        });
      }
    });
  }

  // Update Delivery Address
  @override
  Future<void> updateOrderAddress(String orderId, AddressModel address) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User is not logged in');

    final orderDoc = await _firestore.collection('orders').doc(orderId).get();
    if (!orderDoc.exists) throw Exception('Order not found');

    final orderData = orderDoc.data();
    final items = orderData?['items'] as List<dynamic>? ?? [];

    final shopIds = items
        .map((item) {
          final map = item as Map<String, dynamic>;
          return map['shop_id'] as String;
        })
        .toSet()
        .toList();

    final validatedAddress = await _deliveryValidator.validateAddress(
      address: address,
      shopIds: shopIds,
    );

    await _firestore.collection('orders').doc(orderId).update({
      'delivery_address': validatedAddress.toMap(),
    });
  }

  // Submit Return Request
  @override
  Future<void> submitReturnRequest({
    required String orderId,
    required String itemId,
    required String reason,
    required String details,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User is not logged in');

    final orderRef = _firestore.collection('orders').doc(orderId);
    await _firestore.runTransaction((transaction) async {
      final snap = await transaction.get(orderRef);
      if (!snap.exists) throw Exception('Order not found');

      final data = snap.data()!;
      final itemsRaw = data['items'] as List<dynamic>? ?? [];
      final List<Map<String, dynamic>> items = itemsRaw
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      for (var i = 0; i < items.length; i++) {
        if (items[i]['id'] == itemId) {
          items[i]['return_status'] = 'return_requested';
          items[i]['return_reason'] = reason;
          items[i]['return_details'] = details;
          items[i]['returned_at'] = Timestamp.now();
          break;
        }
      }

      transaction.update(orderRef, {
        'items': items,
        'return_status': 'return_requested',
        'return_reason': reason,
        'return_details': details,
        'returned_item_id': itemId,
        'returned_at': FieldValue.serverTimestamp(),
      });
    });
  }
}
