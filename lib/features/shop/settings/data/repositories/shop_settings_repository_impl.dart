import 'package:street_cart/features/shop/settings/domain/repositories/i_shop_settings_repository.dart';
import 'package:street_cart/features/shop/settings/data/datasources/shop_settings_local_datasource.dart';

class ShopSettingsRepositoryImpl implements IShopSettingsRepository {
  final IShopSettingsLocalDataSource localDataSource;

  ShopSettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Map<String, bool>> getLocalSettings() {
    return localDataSource.getLocalSettings();
  }

  @override
  Future<void> updateLocalSetting(String key, bool value) {
    return localDataSource.updateLocalSetting(key, value);
  }
}
