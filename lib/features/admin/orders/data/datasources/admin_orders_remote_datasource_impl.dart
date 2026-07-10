import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'i_admin_orders_remote_datasource.dart';

class AdminOrdersRemoteDataSourceImpl implements IAdminOrdersRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdminOrdersRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  @override
  Stream<List<OrderModel>> watchAllOrders() {
    return _firestore.collection('orders').snapshots().map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.data(), doc.id);
      }).toList();

      // Sort by newest first
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    });
  }

  @override
  Future<Map<String, String>> fetchShopNamesMap() async {
    try {
      final snapshot = await _firestore.collection('shops').get();
      final Map<String, String> map = {};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final name = data['shop_name'] as String? ?? 'Unknown Shop';
        map[doc.id] = name;
      }
      return map;
    } catch (_) {
      return {};
    }
  }

  @override
  Future<Map<String, ShopProfileModel>> fetchShopProfilesMap() async {
    try {
      final snapshot = await _firestore.collection('shops').get();
      final Map<String, ShopProfileModel> map = {};
      for (final doc in snapshot.docs) {
        map[doc.id] = ShopProfileModel.fromMap(doc.data(), doc.id);
      }
      return map;
    } catch (_) {
      return {};
    }
  }

  @override
  Future<Map<String, String>> fetchCustomerNamesMap() async {
    try {
      final snapshot = await _firestore.collection('customers').get();
      final Map<String, String> map = {};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final name = data['full_name'] ?? data['name'] ?? 'Unknown Customer';
        map[doc.id] = name;
      }
      return map;
    } catch (_) {
      return {};
    }
  }

  @override
  Future<Map<String, String>> fetchCustomerEmailsMap() async {
    try {
      final snapshot = await _firestore.collection('customers').get();
      final Map<String, String> map = {};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final email = data['email'] as String? ?? '';
        map[doc.id] = email;
      }
      return map;
    } catch (_) {
      return {};
    }
  }
}
