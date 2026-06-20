import 'package:street_cart/features/admin/auth/domain/repositories/i_admin_auth_repository.dart';

class ConfirmAdminPasswordReset {
  final IAdminAuthRepository repository;

  ConfirmAdminPasswordReset(this.repository);

  Future<void> call({required String code, required String newPassword}) async {
    await repository.confirmPasswordReset(code: code, newPassword: newPassword);
  }
}
