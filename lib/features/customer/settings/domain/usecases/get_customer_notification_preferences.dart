import 'package:street_cart/features/customer/settings/domain/repositories/settings_repository.dart';

class GetCustomerNotificationPreferences {
  final ISettingsRepository repository;

  GetCustomerNotificationPreferences(this.repository);

  Future<Map<String, bool>> call() async {
    return await repository.getNotificationPreferences();
  }
}
