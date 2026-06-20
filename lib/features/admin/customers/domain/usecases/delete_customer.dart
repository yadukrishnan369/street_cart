import '../repositories/admin_customer_repository.dart';

class DeleteCustomer {
  final IAdminCustomerRepository _repository;

  DeleteCustomer(this._repository);

  Future<void> call(String uid) async {
    await _repository.deleteCustomer(uid);
  }
}
