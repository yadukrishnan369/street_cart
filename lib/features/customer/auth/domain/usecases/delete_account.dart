import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class DeleteAccount {
  final IAuthRepository _repository;

  DeleteAccount(this._repository);

  Future<void> call(String? password) async {
    return await _repository.deleteAccount(password);
  }
}
