import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import '../models/customer_model.dart';

abstract class IAdminCustomerRemoteDataSource {
  Future<List<CustomerModel>> getAllCustomers();
  Future<void> updateCustomerBlockStatus(String uid, bool isBlocked);
  Future<CustomerModel> getCustomerById(String uid);
  Future<List<AddressModel>> getCustomerAddresses(String uid);
  Future<void> deleteCustomer(String uid);
}

class AdminCustomerRemoteDataSourceImpl implements IAdminCustomerRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdminCustomerRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<List<CustomerModel>> getAllCustomers() async {
    try {
      final snap = await _firestore.collection('customers').get();
      return snap.docs.map((doc) {
        return CustomerModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch customers: $e');
    }
  }

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

  @override
  Future<CustomerModel> getCustomerById(String uid) async {
    try {
      final doc = await _firestore.collection('customers').doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        throw Exception('Customer not found');
      }
      return CustomerModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to fetch customer by ID: $e');
    }
  }

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

  @override
  Future<void> deleteCustomer(String uid) async {
    try {
      // Fetch all address documents under the customer's addresses subcollection
      final addressesSnap = await _firestore
          .collection('customers')
          .doc(uid)
          .collection('addresses')
          .get();

      final batch = _firestore.batch();

      //  Add deletion of all addresses in the subcollection to the batch
      for (var doc in addressesSnap.docs) {
        batch.delete(doc.reference);
      }

      // Add deletion of the main customer document to the batch
      batch.delete(_firestore.collection('customers').doc(uid));

      // Add deletion of the user reference document to the batch
      batch.delete(_firestore.collection('users').doc(uid));

      // Commit the batch write
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete customer: $e');
    }
  }
}
