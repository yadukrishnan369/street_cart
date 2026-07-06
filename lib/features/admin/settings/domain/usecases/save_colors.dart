import 'package:street_cart/features/admin/settings/domain/repositories/i_admin_settings_repository.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

class SaveColors {
  final IAdminSettingsRepository _repository;

  SaveColors(this._repository);

  Future<void> call(List<ColorModel> colors) async {
    return _repository.saveColors(colors);
  }
}
