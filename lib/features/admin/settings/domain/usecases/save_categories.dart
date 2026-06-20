import '../repositories/i_admin_settings_repository.dart';
import '../../data/models/admin_settings_model.dart';

class SaveCategories {
  final IAdminSettingsRepository _repository;

  SaveCategories(this._repository);

  Future<void> call({
    required List<CategoryModel> productCategories,
    required List<CategoryModel> businessCategories,
  }) async {
    return _repository.saveCategories(
      productCategories: productCategories,
      businessCategories: businessCategories,
    );
  }
}
