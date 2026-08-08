import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'i_admin_customer_remote_datasource.dart';

class AdminCustomerRemoteDataSourceImpl
    implements IAdminCustomerRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdminCustomerRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;
  // Get All Customers
  @override
  Future<List<CustomerModel>> getAllCustomers() async {
    try {
      // Fetch all customer profile documents
      final customersSnap = await _firestore.collection('customers').get();
      // Fetch orders to calculate count per customer
      final ordersSnap = await _firestore.collection('orders').get();

      final Map<String, int> orderCounts = {};
      for (final orderDoc in ordersSnap.docs) {
        final customerId = orderDoc.data()['customer_id'] as String?;
        if (customerId != null) {
          orderCounts[customerId] = (orderCounts[customerId] ?? 0) + 1;
        }
      }

      return customersSnap.docs.map((doc) {
        final data = doc.data();
        final totalOrders = orderCounts[doc.id] ?? 0;
        return CustomerModel.fromMap({
          ...data,
          'total_orders': totalOrders,
        }, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch customers: $e');
    }
  }

  // Update Customer Block Status
  @override
  Future<void> updateCustomerBlockStatus(String uid, bool isBlocked) async {
    try {
      await _firestore.collection('customers').doc(uid).update({
        'is_blocked': isBlocked,
      });
    } catch (e) {
      throw Exception('Failed to update customer block status: $e');
    }
  }

  // Get Customer By Id
  @override
  Future<CustomerModel> getCustomerById(String uid) async {
    try {
      final doc = await _firestore.collection('customers').doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        throw Exception('Customer not found');
      }

      final ordersSnap = await _firestore
          .collection('orders')
          .where('customer_id', isEqualTo: uid)
          .get();

      final data = doc.data()!;
      return CustomerModel.fromMap({
        ...data,
        'total_orders': ordersSnap.docs.length,
      }, doc.id);
    } catch (e) {
      throw Exception('Failed to fetch customer by ID: $e');
    }
  }

  // Get Customer Addresses
  @override
  Future<List<AddressModel>> getCustomerAddresses(String uid) async {
    try {
      final snap = await _firestore
          .collection('customers')
          .doc(uid)
          .collection('addresses')
          .get();
      return snap.docs
          .map((doc) => AddressModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch customer addresses: $e');
    }
  }

  // Delete Customer
  @override
  Future<void> deleteCustomer(String uid) async {
    try {
      final batch = _firestore.batch();

      // Anonymize Reviews
      final reviewsQuery = await _firestore
          .collection('reviews')
          .where('customer_id', isEqualTo: uid)
          .get();
      for (final doc in reviewsQuery.docs) {
        batch.update(doc.reference, {
          'customer_id': null,
          'customer_name': 'Deleted User',
          'customer_image': '',
        });
      }

      // Flag Orders - NOT delete orders
      final ordersQuery = await _firestore
          .collection('orders')
          .where('customer_id', isEqualTo: uid)
          .get();
      for (final doc in ordersQuery.docs) {
        batch.update(doc.reference, {
          'customer_id': null,
          'customer_deleted': true,
        });
      }

      // Delete Addresses Subcollection
      final addressesQuery = await _firestore
          .collection('customers')
          .doc(uid)
          .collection('addresses')
          .get();
      for (final doc in addressesQuery.docs) {
        batch.delete(doc.reference);
      }

      // Delete Cart Subcollection
      final cartQuery = await _firestore
          .collection('customers')
          .doc(uid)
          .collection('cart')
          .get();
      for (final doc in cartQuery.docs) {
        batch.delete(doc.reference);
      }

      // Delete Wishlist Subcollection
      final wishlistQuery = await _firestore
          .collection('customers')
          .doc(uid)
          .collection('wishlist')
          .get();
      for (final doc in wishlistQuery.docs) {
        batch.delete(doc.reference);
      }

      // Delete the main customer profile document
      batch.delete(_firestore.collection('customers').doc(uid));

      // Delete users credentials collection document
      batch.delete(_firestore.collection('users').doc(uid));

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete customer: $e');
    }
  }
}
