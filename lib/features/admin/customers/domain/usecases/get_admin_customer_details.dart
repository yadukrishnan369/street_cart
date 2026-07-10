import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/admin/customers/domain/repositories/admin_customer_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCustomerDetailsResult {
  final CustomerModel customer;
  final List<AddressModel> addresses;
  final List<OrderModel> orders;

  AdminCustomerDetailsResult({
    required this.customer,
    required this.addresses,
    required this.orders,
  });
}

class GetAdminCustomerDetails {
  final IAdminCustomerRepository _repository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GetAdminCustomerDetails(this._repository);

  Future<AdminCustomerDetailsResult> call(String uid) async {
    final customer = await _repository.getCustomerById(uid);
    final addresses = await _repository.getCustomerAddresses(uid);

    // Fetch customers orders
    final snap = await _firestore
        .collection('orders')
        .where('customer_id', isEqualTo: uid)
        .get();

    final orders = snap.docs.map((doc) {
      return OrderModel.fromMap(doc.data(), doc.id);
    }).toList();

    // Sort newest orders first
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return AdminCustomerDetailsResult(
      customer: customer,
      addresses: addresses,
      orders: orders,
    );
  }
}
