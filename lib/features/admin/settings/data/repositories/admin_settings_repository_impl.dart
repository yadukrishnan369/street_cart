import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/admin/settings/domain/repositories/i_admin_settings_repository.dart';
import 'package:street_cart/features/admin/settings/data/datasources/admin_settings_remote_datasource.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

class AdminSettingsRepositoryImpl implements IAdminSettingsRepository {
  final IAdminSettingsRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  AdminSettingsRepositoryImpl({
    required IAdminSettingsRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  Future<void> _checkConnection() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
  }

  @override
  Future<AdminSettingsModel> getSettings() async {
    await _checkConnection();
    return _remoteDataSource.getSettings();
  }

  @override
  Future<void> savePlatformCommission(double percentage) async {
    await _checkConnection();
    return _remoteDataSource.savePlatformCommission(percentage);
  }

  @override
  Future<void> savePaymentControls({
    required bool enableCod,
    required bool enableOnline,
  }) async {
    await _checkConnection();
    return _remoteDataSource.savePaymentControls(
      enableCod: enableCod,
      enableOnline: enableOnline,
    );
  }

  @override
  Future<void> changeAdminPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _checkConnection();
    return _remoteDataSource.changeAdminPassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> saveCategories({
    required List<CategoryModel> productCategories,
    required List<CategoryModel> businessCategories,
  }) async {
    await _checkConnection();
    return _remoteDataSource.saveCategories(
      productCategories: productCategories,
      businessCategories: businessCategories,
    );
  }

  @override
  Future<ProductConfigModel> getProductConfig() async {
    await _checkConnection();
    return _remoteDataSource.getProductConfig();
  }

  @override
  Future<void> saveColors(List<ColorModel> colors) async {
    await _checkConnection();
    return _remoteDataSource.saveColors(colors);
  }

  @override
  Future<void> saveSizeGroups(List<SizeGroupModel> sizeGroups) async {
    await _checkConnection();
    return _remoteDataSource.saveSizeGroups(sizeGroups);
  }
}
