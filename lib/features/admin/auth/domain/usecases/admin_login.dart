import 'package:street_cart/features/admin/auth/domain/repositories/i_admin_auth_repository.dart';

class AdminLogin {
  final IAdminAuthRepository repository;

  AdminLogin(this.repository);

  Future<bool> call({required String email, required String password}) async {
    return await repository.login(email: email, password: password);
  }
}
