import 'package:street_cart/features/customer/settings/domain/repositories/settings_repository.dart';
import 'package:street_cart/features/customer/settings/data/datasources/settings_local_datasource.dart';
import 'package:street_cart/features/customer/settings/data/datasources/settings_remote_datasource.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final ISettingsLocalDataSource localDataSource;
  final ISettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Map<String, dynamic>> getSettings() async {
    return await localDataSource.getSettings();
  }

  @override
  Future<void> updateSetting(String key, dynamic value) async {
    await localDataSource.updateSetting(key, value);
  }

  @override
  Future<Map<String, bool>> getNotificationPreferences() async {
    return await remoteDataSource.getNotificationPreferences();
  }

  @override
  Future<void> saveNotificationPreference(String key, bool value) async {
    await remoteDataSource.saveNotificationPreference(key, value);
  }
}
