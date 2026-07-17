import 'package:shared_preferences/shared_preferences.dart';

abstract class ISettingsLocalDataSource {
  Future<Map<String, dynamic>> getSettings();
  Future<void> updateSetting(String key, dynamic value);
}

class SettingsLocalDataSourceImpl implements ISettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  SettingsLocalDataSourceImpl({required this.sharedPreferences});

  // Get Theme, Location Access, Notifications, Order Alerts data
  @override
  Future<Map<String, dynamic>> getSettings() async {
    return {
      'darkMode': sharedPreferences.getBool('darkMode') ?? false,
      'locationServices': sharedPreferences.getBool('locationServices') ?? true,
      'pushNotifications':
          sharedPreferences.getBool('pushNotifications') ?? true,
      'orderAlerts': sharedPreferences.getBool('orderAlerts') ?? true,
    };
  }

  // Update Theme, Location Access, Notifications, Order Alerts data
  @override
  Future<void> updateSetting(String key, dynamic value) async {
    if (value is bool) {
      await sharedPreferences.setBool(key, value);
    } else if (value is String) {
      await sharedPreferences.setString(key, value);
    } else if (value is int) {
      await sharedPreferences.setInt(key, value);
    } else if (value is double) {
      await sharedPreferences.setDouble(key, value);
    }
  }
}
