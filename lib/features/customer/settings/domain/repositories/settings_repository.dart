abstract class ISettingsRepository {
  Future<Map<String, dynamic>> getSettings();
  Future<void> updateSetting(String key, dynamic value);
}
