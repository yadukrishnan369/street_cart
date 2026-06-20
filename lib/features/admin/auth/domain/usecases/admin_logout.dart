import 'package:street_cart/features/admin/auth/domain/repositories/i_admin_auth_repository.dart';

class AdminLogout {
  final IAdminAuthRepository repository;

  AdminLogout(this.repository);

  Future<void> call() async {
    await repository.logout();
  }
}
