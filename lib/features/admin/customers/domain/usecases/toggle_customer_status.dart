import '../repositories/admin_customer_repository.dart';

class ToggleCustomerBlockStatusParams {
  final String uid;
  final bool isBlocked;

  ToggleCustomerBlockStatusParams({
    required this.uid,
    required this.isBlocked,
  });
}

class ToggleCustomerBlockStatus {
  final IAdminCustomerRepository _repository;

  ToggleCustomerBlockStatus(this._repository);

  Future<void> call(ToggleCustomerBlockStatusParams params) async {
    return await _repository.toggleCustomerBlockStatus(
      uid: params.uid,
      isBlocked: params.isBlocked,
    );
  }
}
