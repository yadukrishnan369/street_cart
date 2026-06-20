import '../../data/models/admin_settings_model.dart';
import '../repositories/i_admin_settings_repository.dart';

class GetAdminSettings {
  final IAdminSettingsRepository _repository;

  GetAdminSettings(this._repository);

  Future<AdminSettingsModel> call() async {
    return _repository.getSettings();
  }
}
