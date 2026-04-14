import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class Login {
  final IAuthRepository repository;

  Login(this.repository);

  Future<void> call({required String email, required String password}) async {
    await repository.login(email: email, password: password);
  }
}
