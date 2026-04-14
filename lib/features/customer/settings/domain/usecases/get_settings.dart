import 'package:street_cart/features/customer/settings/domain/repositories/settings_repository.dart';

class GetSettings {
  final ISettingsRepository repository;

  GetSettings(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.getSettings();
  }
}
