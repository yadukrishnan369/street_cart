import 'package:street_cart/features/customer/settings/domain/repositories/settings_repository.dart';
import 'package:street_cart/features/customer/settings/data/datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final ISettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Map<String, dynamic>> getSettings() async {
    return await localDataSource.getSettings();
  }

  @override
  Future<void> updateSetting(String key, dynamic value) async {
    await localDataSource.updateSetting(key, value);
  }
}
