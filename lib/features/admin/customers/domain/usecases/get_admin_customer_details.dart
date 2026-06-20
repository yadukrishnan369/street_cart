import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import '../../data/models/customer_model.dart';
import '../repositories/admin_customer_repository.dart';

class AdminCustomerDetailsResult {
  final CustomerModel customer;
  final List<AddressModel> addresses;

  AdminCustomerDetailsResult({
    required this.customer,
    required this.addresses,
  });
}

class GetAdminCustomerDetails {
  final IAdminCustomerRepository _repository;

  GetAdminCustomerDetails(this._repository);

  Future<AdminCustomerDetailsResult> call(String uid) async {
    final customer = await _repository.getCustomerById(uid);
    final addresses = await _repository.getCustomerAddresses(uid);
    return AdminCustomerDetailsResult(customer: customer, addresses: addresses);
  }
}
