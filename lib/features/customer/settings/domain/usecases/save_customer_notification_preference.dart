import 'package:street_cart/features/customer/settings/domain/repositories/settings_repository.dart';

class SaveCustomerNotificationPreference {
  final ISettingsRepository repository;

  SaveCustomerNotificationPreference(this.repository);

  Future<void> call(String key, bool value) async {
    await repository.saveNotificationPreference(key, value);
  }
}
