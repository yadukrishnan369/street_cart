abstract class IShopSettingsRepository {
  Future<Map<String, bool>> getLocalSettings();
  Future<void> updateLocalSetting(String key, bool value);
}
