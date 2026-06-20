import '../repositories/i_admin_settings_repository.dart';

class ChangeAdminPassword {
  final IAdminSettingsRepository _repository;

  ChangeAdminPassword(this._repository);

  Future<void> call({required String currentPassword, required String newPassword}) async {
    return _repository.changeAdminPassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
