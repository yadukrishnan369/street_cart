import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'payment_remote_datasource.dart';

class PaymentRemoteDataSourceImpl implements IPaymentRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  PaymentRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _firestore = firestore;

  @override
  Future<String> placeOrder({
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

    final orderRef = _firestore.collection('orders').doc();

    await _firestore.runTransaction((transaction) async {
      // Fetch product document
      final Map<String, DocumentSnapshot<Map<String, dynamic>>>
      productSnapshots = {};
      for (final item in items) {
        if (!productSnapshots.containsKey(item.productId)) {
          final productDocRef = _firestore
              .collection('products')
              .doc(item.productId);
          final productDoc = await transaction.get(productDocRef);
          productSnapshots[item.productId] = productDoc;
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
        final cartDocSnapshot = await transaction.get(cartDocRef);
        cartDocExists[item.id] = cartDocSnapshot.exists;
      }

      // Fetch admin commission percentage
      final configSettingsRef = _firestore.collection('config').doc('settings');
      final configSettingsDoc = await transaction.get(configSettingsRef);
      double commissionPercentage = 2.0; // Default fallback
      if (configSettingsDoc.exists) {
        final configData = configSettingsDoc.data();
        if (configData != null &&
            configData.containsKey('commission_percentage')) {
          commissionPercentage = (configData['commission_percentage'] as num)
              .toDouble();
        }
      }
      final double commissionRate = commissionPercentage / 100.0;

      // VALIDATIONS
      // Process and update stock
      for (final item in items) {
        final productDoc = productSnapshots[item.productId]!;
        if (!productDoc.exists) {
          throw Exception('Product ${item.productName} does not exist.');
        }

        final productData = productDoc.data()!;
        final variantsRaw = productData['variants'] as List<dynamic>? ?? [];

        if (variantsRaw.isEmpty) {
          final currentStock =
              (productData['stockQuantity'] as num?)?.toInt() ?? 0;
          if (currentStock < item.quantity) {
            throw Exception('Insufficient stock for ${item.productName}.');
          }
          // Deduct stock
          transaction.update(productDoc.reference, {
            'stockQuantity': currentStock - item.quantity,
          });
        } else {
          // Find matching variant
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
                throw Exception(
                  'Insufficient stock for ${item.productName} (${item.selectedColor}/${item.selectedSize}).',
                );
              }
              // Deduct stock
              sizes[item.selectedSize!] = currentStock - item.quantity;
              variant['sizes'] = sizes;
              variant['total_stock'] = sizes.values.fold(
                0,
                (acc, qty) => acc + (qty as num).toInt(),
              );
              transaction.update(productDoc.reference, {'variants': variants});
            }
          }
          if (!foundVariant) {
            throw Exception(
              'Selected variant for ${item.productName} not found.',
            );
          }
        }
      }

      // Clear items from customer cart
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

      // Create Order Document
      double totalAdminCommission = 0.0;
      final Map<String, double> calculatedShopEarnings = {};

      final itemsData = items.map((item) {
        final itemTotal = item.price * item.quantity;
        final itemCommission = itemTotal * commissionRate;
        final itemEarnings = itemTotal - itemCommission;

        totalAdminCommission += itemCommission;
        calculatedShopEarnings[item.shopId] =
            (calculatedShopEarnings[item.shopId] ?? 0.0) + itemEarnings;

        return {
          'id': item.id,
          'product_id': item.productId,
          'product_name': item.productName,
          'product_image': item.productImage,
          'selected_size': item.selectedSize,
          'selected_color': item.selectedColor,
          'price': item.price,
          'quantity': item.quantity,
          'shop_id': item.shopId,
          'admin_commission': itemCommission,
          'vendor_earnings': itemEarnings,
        };
      }).toList();

      final orderData = {
        'id': orderRef.id,
        'customer_id': user.uid,
        'items': itemsData,
        'delivery_address': address.toMap(),
        'payment_method': paymentMethod,
        'payment_status': paymentStatus,
        'total_amount': totalAmount,
        'admin_commission': totalAdminCommission,
        'shop_earnings': calculatedShopEarnings,
        'status': 'pending',
        'created_at': FieldValue.serverTimestamp(),
      };

      transaction.set(orderRef, orderData);
    });

    return orderRef.id;
  }
}
