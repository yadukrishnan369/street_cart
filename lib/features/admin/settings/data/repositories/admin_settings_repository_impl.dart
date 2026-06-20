import '../../domain/repositories/i_admin_settings_repository.dart';
import '../datasources/admin_settings_remote_datasource.dart';
import '../models/admin_settings_model.dart';

class AdminSettingsRepositoryImpl implements IAdminSettingsRepository {
  final IAdminSettingsRemoteDataSource _remoteDataSource;

  AdminSettingsRepositoryImpl({
    required IAdminSettingsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<AdminSettingsModel> getSettings() async {
    return _remoteDataSource.getSettings();
  }

  @override
  Future<void> savePlatformCommission(double percentage) async {
    return _remoteDataSource.savePlatformCommission(percentage);
  }

  @override
  Future<void> savePaymentControls({
    required bool enableCod,
    required bool enableOnline,
  }) async {
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
    return _remoteDataSource.saveCategories(
      productCategories: productCategories,
      businessCategories: businessCategories,
    );
  }
}
