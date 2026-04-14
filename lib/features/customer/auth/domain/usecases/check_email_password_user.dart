import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class CheckEmailPasswordUser {
  final IAuthRepository repository;

  CheckEmailPasswordUser(this.repository);

  Future<bool> call() async {
    return await repository.isEmailPasswordUser();
  }
}
