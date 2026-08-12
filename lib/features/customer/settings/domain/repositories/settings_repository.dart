abstract class ISettingsRepository {
  Future<Map<String, dynamic>> getSettings();
  Future<void> updateSetting(String key, dynamic value);
  Future<Map<String, bool>> getNotificationPreferences();
  Future<void> saveNotificationPreference(String key, bool value);
}
