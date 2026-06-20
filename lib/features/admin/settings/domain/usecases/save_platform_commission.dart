import '../repositories/i_admin_settings_repository.dart';

class SavePlatformCommission {
  final IAdminSettingsRepository _repository;

  SavePlatformCommission(this._repository);

  Future<void> call(double percentage) async {
    return _repository.savePlatformCommission(percentage);
  }
}
