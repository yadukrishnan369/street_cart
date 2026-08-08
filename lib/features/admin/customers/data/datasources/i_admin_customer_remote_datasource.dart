import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';

abstract class IAdminCustomerRemoteDataSource {
  Future<List<CustomerModel>> getAllCustomers();

  Future<void> updateCustomerBlockStatus(String uid, bool isBlocked);

  Future<CustomerModel> getCustomerById(String uid);

  Future<List<AddressModel>> getCustomerAddresses(String uid);

  Future<void> deleteCustomer(String uid);
}
