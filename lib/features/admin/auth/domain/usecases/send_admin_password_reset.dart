import 'package:street_cart/features/admin/auth/domain/repositories/i_admin_auth_repository.dart';

class SendAdminPasswordReset {
  final IAdminAuthRepository repository;

  SendAdminPasswordReset(this.repository);

  Future<void> call(String email) async {
    await repository.sendPasswordResetEmail(email);
  }
}
