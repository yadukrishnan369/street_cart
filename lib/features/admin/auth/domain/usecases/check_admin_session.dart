import 'package:street_cart/features/admin/auth/domain/repositories/i_admin_auth_repository.dart';

class CheckAdminSession {
  final IAdminAuthRepository repository;

  CheckAdminSession(this.repository);

  Future<bool> call() async {
    return await repository.checkSession();
  }
}
