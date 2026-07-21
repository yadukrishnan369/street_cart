import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';

class AdminCustomerResponse {
  final List<CustomerModel> customers;
  final int totalMatchingCount;
  final int totalCustomers;
  final int activeCustomers;
  final int blockedCustomers;

  AdminCustomerResponse({
    required this.customers,
    required this.totalMatchingCount,
    required this.totalCustomers,
    required this.activeCustomers,
    required this.blockedCustomers,
  });
}

abstract class IAdminCustomerRepository {
  Future<AdminCustomerResponse> getCustomers({
    required int page,
    required int limit,
    String? searchQuery,
    String? statusFilter,
  });

  Future<void> toggleCustomerBlockStatus({
    required String uid,
    required bool isBlocked,
  });

  Future<CustomerModel> getCustomerById(String uid);

  Future<List<AddressModel>> getCustomerAddresses(String uid);

  Future<void> deleteCustomer(String uid);
}
