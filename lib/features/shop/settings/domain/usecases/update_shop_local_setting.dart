import 'package:street_cart/features/shop/settings/domain/repositories/i_shop_settings_repository.dart';

class UpdateShopLocalSetting {
  final IShopSettingsRepository repository;

  UpdateShopLocalSetting(this.repository);

  Future<void> call(String key, bool value) {
    return repository.updateLocalSetting(key, value);
  }
}
