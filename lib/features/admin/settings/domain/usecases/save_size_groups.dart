import 'package:street_cart/features/admin/settings/domain/repositories/i_admin_settings_repository.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';

class SaveSizeGroups {
  final IAdminSettingsRepository _repository;

  SaveSizeGroups(this._repository);

  Future<void> call(List<SizeGroupModel> sizeGroups) async {
    return _repository.saveSizeGroups(sizeGroups);
  }
}
