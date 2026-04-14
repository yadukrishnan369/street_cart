import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class CheckEmailVerification {
  final IAuthRepository repository;

  CheckEmailVerification(this.repository);

  Future<bool> call() async {
    return await repository.checkEmailVerification();
  }
}
