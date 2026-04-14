import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class Logout {
  final IAuthRepository repository;

  Logout(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}
