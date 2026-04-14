import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class SignUp {
  final IAuthRepository repository;

  SignUp(this.repository);

  Future<void> call({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await repository.initiateSignUp(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}

