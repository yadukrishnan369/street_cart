import 'package:street_cart/features/admin/settings/domain/repositories/i_admin_settings_repository.dart';

class SavePaymentControls {
  final IAdminSettingsRepository _repository;

  SavePaymentControls(this._repository);

  Future<void> call({
    required bool enableCod,
    required bool enableOnline,
  }) async {
    return _repository.savePaymentControls(
      enableCod: enableCod,
      enableOnline: enableOnline,
    );
  }
}
