import 'package:street_cart/features/admin/settings/domain/repositories/i_admin_settings_repository.dart';

class SaveAdminNotificationPreference {
  final IAdminSettingsRepository repository;

  SaveAdminNotificationPreference(this.repository);

  Future<void> call(String key, bool value) async {
    await repository.saveNotificationPreference(key, value);
  }
}
