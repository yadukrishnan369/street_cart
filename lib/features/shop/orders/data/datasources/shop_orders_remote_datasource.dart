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

  // Update Order Return Status
  @override
  Future<void> updateReturnStatus(String orderId, String returnStatus) async {
    final orderRef = _firestore.collection('orders').doc(orderId);
    await _firestore.runTransaction((transaction) async {
      final snap = await transaction.get(orderRef);
      if (!snap.exists) throw Exception('Order not found');

      final orderData = snap.data()!;
      final itemsRaw = orderData['items'] as List<dynamic>? ?? [];
      final List<Map<String, dynamic>> items = itemsRaw
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      // Collect all items to restock
      final List<Map<String, dynamic>> itemsToRestock = [];
      if (returnStatus == 'return_picked') {
        for (var i = 0; i < items.length; i++) {
          final itemId = items[i]['id'] as String;
          final oldItem = itemsRaw.firstWhere(
            (it) => it['id'] == itemId,
            orElse: () => null,
          );
          final oldStatus = oldItem != null
              ? oldItem['return_status'] as String?
              : null;

          final itemStatus = items[i]['return_status'] as String?;
          if (itemStatus != null && itemStatus.isNotEmpty) {
            if (oldStatus != 'return_picked' &&
                (itemStatus == 'return_confirmed' ||
                    itemStatus == 'return_requested')) {
              itemsToRestock.add(items[i]);
            }
          }
        }
      }

      // Retrieve all target product documents
      final Map<String, DocumentSnapshot<Map<String, dynamic>>> productSnaps =
          {};
      for (final item in itemsToRestock) {
        final productId = item['product_id'] as String? ?? '';
        // avoid duplicate items
        if (productId.isNotEmpty && !productSnaps.containsKey(productId)) {
          final productRef = _firestore.collection('products').doc(productId);
          productSnaps[productId] = await transaction.get(productRef);
        }
      }

      // Update items status locally
      for (var i = 0; i < items.length; i++) {
        final itemStatus = items[i]['return_status'] as String?;
        if (itemStatus != null && itemStatus.isNotEmpty) {
          if (returnStatus == 'return_confirmed' &&
              itemStatus == 'return_requested') {
            items[i]['return_status'] = 'return_confirmed';
            items[i]['return_confirmed_at'] = Timestamp.now();
          } else if (returnStatus == 'return_picked' &&
              (itemStatus == 'return_confirmed' ||
                  itemStatus == 'return_requested')) {
            items[i]['return_status'] = 'return_picked';
            items[i]['return_picked_at'] = Timestamp.now();
          }
        }
      }

      // Perform Stock Updates
      for (final item in itemsToRestock) {
        final productId = item['product_id'] as String? ?? '';
        final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
        final selectedColor = item['selected_color'] as String?;
        final selectedSize = item['selected_size'] as String?;

        if (productId.isNotEmpty && quantity > 0) {
          final productSnap = productSnaps[productId];
          if (productSnap != null && productSnap.exists) {
            final productData = productSnap.data()!;
            final variantsRaw = productData['variants'] as List<dynamic>? ?? [];
            if (variantsRaw.isEmpty) {
              final currentStock =
                  (productData['stockQuantity'] as num?)?.toInt() ?? 0;
              transaction.update(productSnap.reference, {
                'stockQuantity': currentStock + quantity,
              });
            } else {
              final List<Map<String, dynamic>> variants = variantsRaw
                  .map((v) => Map<String, dynamic>.from(v as Map))
                  .toList();
              for (var j = 0; j < variants.length; j++) {
                final variant = variants[j];
                if (variant['color_name'] == selectedColor) {
                  final sizes = Map<String, dynamic>.from(
                    variant['sizes'] as Map? ?? {},
                  );
                  if (selectedSize != null) {
                    final currentSizeStock =
                        (sizes[selectedSize] as num?)?.toInt() ?? 0;
                    sizes[selectedSize] = currentSizeStock + quantity;
                    variant['sizes'] = sizes;
                  }
                  variant['total_stock'] = sizes.values.fold(
                    0,
                    (acc, qty) => acc + (qty as num).toInt(),
                  );
                  break;
                }
              }
              transaction.update(productSnap.reference, {'variants': variants});
            }
          }
        }
      }

      // Update order document
      final Map<String, dynamic> updates = {
        'items': items,
        'return_status': returnStatus,
      };
      if (returnStatus == 'return_confirmed') {
        updates['return_confirmed_at'] = FieldValue.serverTimestamp();
      } else if (returnStatus == 'return_picked') {
        updates['return_picked_at'] = FieldValue.serverTimestamp();
      }

      transaction.update(orderRef, updates);
    });
  }
}
