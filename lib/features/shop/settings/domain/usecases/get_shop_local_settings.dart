import 'package:street_cart/features/shop/settings/domain/repositories/i_shop_settings_repository.dart';

class GetShopLocalSettings {
  final IShopSettingsRepository repository;

  GetShopLocalSettings(this.repository);

  Future<Map<String, bool>> call() {
    return repository.getLocalSettings();
  }
}
