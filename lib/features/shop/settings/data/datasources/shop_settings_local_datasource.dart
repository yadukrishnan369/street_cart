import 'package:shared_preferences/shared_preferences.dart';

// Interfaces
abstract class IShopSettingsLocalDataSource {
  Future<Map<String, bool>> getLocalSettings();
  Future<void> updateLocalSetting(String key, bool value);
}

class ShopSettingsLocalDataSourceImpl implements IShopSettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  ShopSettingsLocalDataSourceImpl({required this.sharedPreferences});
  // Get Local Settings
  @override
  Future<Map<String, bool>> getLocalSettings() async {
    return {
      'generalNotifications':
          sharedPreferences.getBool('generalNotifications') ?? true,
      'orderAlerts': sharedPreferences.getBool('orderAlerts') ?? true,
    };
  }

  // Update Local Setting
  @override
  Future<void> updateLocalSetting(String key, bool value) async {
    await sharedPreferences.setBool(key, value);
  }
}
