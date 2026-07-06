import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

abstract class IAdminSettingsRepository {
  Future<AdminSettingsModel> getSettings();
  Future<void> savePlatformCommission(double percentage);
  Future<void> savePaymentControls({
    required bool enableCod,
    required bool enableOnline,
  });
  Future<void> changeAdminPassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<void> saveCategories({
    required List<CategoryModel> productCategories,
    required List<CategoryModel> businessCategories,
  });
  Future<ProductConfigModel> getProductConfig();
  Future<void> saveColors(List<ColorModel> colors);
  Future<void> saveSizeGroups(List<SizeGroupModel> sizeGroups);
}
