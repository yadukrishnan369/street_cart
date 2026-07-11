import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/orders/data/datasources/i_orders_remote_datasource.dart';

class OrdersRemoteDataSourceImpl implements IOrdersRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  OrdersRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

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

  @override
  Future<void> updateOrderAddress(String orderId, AddressModel address) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User is not logged in');

    await _firestore.collection('orders').doc(orderId).update({
      'delivery_address': address.toMap(),
    });
  }
}
