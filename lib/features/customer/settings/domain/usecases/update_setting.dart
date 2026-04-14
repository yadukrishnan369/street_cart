import 'package:street_cart/features/customer/settings/domain/repositories/settings_repository.dart';

class UpdateSetting {
  final ISettingsRepository repository;

  UpdateSetting(this.repository);

  Future<void> call(String key, dynamic value) async {
    await repository.updateSetting(key, value);
  }
}
