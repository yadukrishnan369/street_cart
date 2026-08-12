import 'package:street_cart/features/admin/settings/domain/repositories/i_admin_settings_repository.dart';

class GetAdminNotificationPreferences {
  final IAdminSettingsRepository repository;

  GetAdminNotificationPreferences(this.repository);

  Future<Map<String, bool>> call() async {
    return await repository.getNotificationPreferences();
  }
}
