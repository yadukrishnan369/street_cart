import 'package:street_cart/features/admin/settings/domain/repositories/i_admin_settings_repository.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/send_shop_notification.dart';

class SavePlatformCommission {
  final IAdminSettingsRepository _repository;
  final SendShopNotification _sendShopNotification;

  SavePlatformCommission(this._repository, this._sendShopNotification);

  Future<void> call(double percentage) async {
    final shopIds = await _repository.savePlatformCommission(percentage);

    for (final shopId in shopIds) {
      try {
        // Send platform commission update to shop
        await _sendShopNotification.sendCommissionUpdate(
          shopId: shopId,
          percentage: percentage,
        );
      } catch (_) {}
    }
  }
}
