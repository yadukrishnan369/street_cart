import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/core/utils/delivery_validator.dart';
import 'payment_remote_datasource.dart';

class PaymentRemoteDataSourceImpl implements IPaymentRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final DeliveryValidator _deliveryValidator;

  PaymentRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required DeliveryValidator deliveryValidator,
  }) : _auth = auth,
       _firestore = firestore,
       _deliveryValidator = deliveryValidator;
  // Place Order
  @override
  Future<Map<String, dynamic>> placeOrder({
    required List<CartItem> items,
    required AddressModel address,
    required String paymentMethod,
    required String paymentStatus,
    required double totalAmount,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }

    // validate radius distance for all shops
    final shopIds = items.map((e) => e.shopId).toSet().toList();
    final validatedAddress = await _deliveryValidator.validateAddress(
      address: address,
      shopIds: shopIds,
    );

    // Group items - Each shop gets its own separate order
    final Map<String, List<CartItem>> itemsByShop = {};
    for (final item in items) {
      itemsByShop.putIfAbsent(item.shopId, () => []).add(item);
    }

    // create a DocumentReference per shop
    final Map<String, DocumentReference> orderRefs = {
      for (final shopId in itemsByShop.keys)
        shopId: _firestore.collection('orders').doc(),
    };

    await _firestore.runTransaction((transaction) async {
      // Fetch all product snapshots
      final Map<String, DocumentSnapshot<Map<String, dynamic>>>
      productSnapshots = {};
      for (final item in items) {
        if (!productSnapshots.containsKey(item.productId)) {
          final ref = _firestore.collection('products').doc(item.productId);
          productSnapshots[item.productId] = await transaction.get(ref);
        }
      }

      // Fetch cart document snapshots
      final Map<String, bool> cartDocExists = {};
      for (final item in items) {
        final cartDocRef = _firestore
            .collection('customers')
            .doc(user.uid)
            .collection('cart')
            .doc(item.id);
        final snap = await transaction.get(cartDocRef);
        cartDocExists[item.id] = snap.exists;
      }

      // Fetch admin commission percentage
      final configRef = _firestore.collection('config').doc('settings');
      final configDoc = await transaction.get(configRef);
      double commissionPercentage = 2.0; // Default fallback
      if (configDoc.exists) {
        final data = configDoc.data();
        if (data != null && data.containsKey('commission_percentage')) {
          commissionPercentage = (data['commission_percentage'] as num)
              .toDouble();
        }
      }
      final double commissionRate = commissionPercentage / 100.0;

      final errors = <String>[];

      // Validate stock & deduct for ALL items
      for (final item in items) {
        final productDoc = productSnapshots[item.productId]!;
        if (!productDoc.exists) {
          errors.add('Product ${item.productName} does not exist.');
          continue;
        }

        final productData = productDoc.data()!;
        final isActive = productData['is_active'] as bool? ?? true;
        final disabledByAdmin =
            productData['disabled_by_admin'] as bool? ?? false;

        if (!isActive || disabledByAdmin) {
          errors.add('Product ${item.productName} is no longer available.');
          continue;
        }

        final variantsRaw = productData['variants'] as List<dynamic>? ?? [];

        if (variantsRaw.isEmpty) {
          final currentStock =
              (productData['stock_quantity'] ??
                      productData['stockQuantity'] as num?)
                  ?.toInt() ??
              0;
          if (currentStock < item.quantity) {
            errors.add('Insufficient stock for ${item.productName}.');
            continue;
          }
          transaction.update(productDoc.reference, {
            'stock_quantity': currentStock - item.quantity,
          });
        } else {
          final List<Map<String, dynamic>> variants = variantsRaw
              .map((v) => Map<String, dynamic>.from(v as Map))
              .toList();
          bool foundVariant = false;

          for (var i = 0; i < variants.length; i++) {
            final variant = variants[i];
            if (variant['color_name'] == item.selectedColor) {
              foundVariant = true;
              final sizes = Map<String, dynamic>.from(
                variant['sizes'] as Map? ?? {},
              );
              final currentStock =
                  (sizes[item.selectedSize] as num?)?.toInt() ?? 0;
              if (currentStock < item.quantity) {
                errors.add(
                  'Insufficient stock for ${item.productName}'
                  ' (${item.selectedColor}/${item.selectedSize}).',
                );
                break;
              }
              sizes[item.selectedSize!] = currentStock - item.quantity;
              variant['sizes'] = sizes;
              variant['total_stock'] = sizes.values.fold(
                0,
                (acc, qty) => acc + (qty as num).toInt(),
              );

              // Recalculate total product stock across variants
              final int newTotalStock = variants.fold(
                0,
                (sum, v) => sum + ((v['total_stock'] ?? 0) as num).toInt(),
              );

              transaction.update(productDoc.reference, {
                'variants': variants,
                'stock_quantity': newTotalStock,
              });
              break;
            }
          }
          if (!foundVariant) {
            errors.add('Selected variant for ${item.productName} not found.');
          }
        }
      }

      if (errors.isNotEmpty) {
        throw Exception(errors.join('\n'));
      }

      // Delete cart items for ALL items
      for (final item in items) {
        if (cartDocExists[item.id] == true) {
          final cartDocRef = _firestore
              .collection('customers')
              .doc(user.uid)
              .collection('cart')
              .doc(item.id);
          transaction.delete(cartDocRef);
        }
      }

      // Create ONE order document PER SHOP
      for (final entry in itemsByShop.entries) {
        final shopId = entry.key;
        final shopItems = entry.value;
        final orderRef = orderRefs[shopId]!;

        double shopSubtotal = 0.0;
        double shopCommission = 0.0;
        double shopVendorEarnings = 0.0;

        final itemsData = shopItems.map((item) {
          final itemTotal = item.price * item.quantity;
          final itemCommission = itemTotal * commissionRate;
          final itemEarnings = itemTotal - itemCommission;

          shopSubtotal += itemTotal;
          shopCommission += itemCommission;
          shopVendorEarnings += itemEarnings;

          return {
            'id': item.id,
            'product_id': item.productId,
            'product_name': item.productName,
            'product_image': item.productImage,
            'selected_size': item.selectedSize,
            'selected_color': item.selectedColor,
            'price': item.price,
            'quantity': item.quantity,
            'shop_id': shopId,
            'admin_commission': itemCommission,
            'vendor_earnings': itemEarnings,
          };
        }).toList();

        final orderData = {
          'id': orderRef.id,
          'customer_id': user.uid,
          'items': itemsData,
          'delivery_address': validatedAddress.toMap(),
          'payment_method': paymentMethod,
          'payment_status': paymentStatus,
          'total_amount': shopSubtotal,
          'admin_commission': shopCommission,
          'shop_earnings': {shopId: shopVendorEarnings},
          'status': 'pending',
          'created_at': FieldValue.serverTimestamp(),
        };

        transaction.set(orderRef, orderData);
      }
    });

    final Map<String, String> shopOrderIds = {};
    for (final entry in orderRefs.entries) {
      shopOrderIds[entry.key] = entry.value.id;
    }

    return {
      'firstOrderId': orderRefs.values.first.id,
      'shopOrderIds': shopOrderIds,
    };
  }
}
