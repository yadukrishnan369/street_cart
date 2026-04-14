import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class SignInWithGoogle {
  final IAuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<bool> call() async {
    return await repository.signInWithGoogle();
  }
}
