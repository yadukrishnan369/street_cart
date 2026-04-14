import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class ChangePassword {
  final IAuthRepository repository;

  ChangePassword(this.repository);

  Future<void> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
