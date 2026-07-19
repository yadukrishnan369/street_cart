import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/data/datasources/i_shop_orders_remote_datasource.dart';

class ShopOrdersRemoteDataSourceImpl implements IShopOrdersRemoteDataSource {
  final FirebaseFirestore _firestore;

  ShopOrdersRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  // Watching Orders update - Fetch and React Order Changes
  @override
  Stream<List<OrderModel>> watchShopOrders(String shopId) {
    return _firestore.collection('orders').snapshots().map((querySnapshot) {
      final allOrders = querySnapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), doc.id);
      }).toList();

      // Filter for only this shops non cancelled orders
      final filtered = allOrders.where((order) {
        final isCancelled = order.status.toLowerCase() == 'cancelled';
        final hasShopItem = order.items.any((item) => item.shopId == shopId);
        return hasShopItem && !isCancelled;
      }).toList();

      // Sort by newest first
      filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return filtered;
    });
  }

  // Updates an order status
  @override
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final status = newStatus.toLowerCase();
    // Timestamp field name
    const statusTimestampMap = {
      'processing': 'confirmed_at',
      'packed': 'processing_at',
      'shipped': 'shipped_at',
      'delivered': 'delivered_at',
    };
    final Map<String, dynamic> updates = {'status': status};
    final timestampField = statusTimestampMap[status];
    if (timestampField != null) {
      updates[timestampField] = FieldValue.serverTimestamp();
    }
    if (status == 'delivered') {
      updates['payment_status'] = 'paid';
      try {
        final orderDoc = await _firestore
            .collection('orders')
            .doc(orderId)
            .get();
        if (orderDoc.exists && orderDoc.data() != null) {
          final data = orderDoc.data()!;
          final items = data['items'] as List<dynamic>? ?? [];
          for (final item in items) {
            final productId = item['product_id']?.toString() ?? '';
            final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
            if (productId.isNotEmpty && quantity > 0) {
              // Increment Sales Count
              await _firestore.collection('products').doc(productId).update({
                'sales_count': FieldValue.increment(quantity),
              });
            }
          }
        }
      } catch (_) {}
    }
    await _firestore.collection('orders').doc(orderId).update(updates);
  }
}
