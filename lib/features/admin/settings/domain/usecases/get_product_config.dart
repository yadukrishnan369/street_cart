import 'package:street_cart/features/admin/settings/domain/repositories/i_admin_settings_repository.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

class GetProductConfig {
  final IAdminSettingsRepository _repository;

  GetProductConfig(this._repository);

  Future<ProductConfigModel> call() async {
    return _repository.getProductConfig();
  }
}
