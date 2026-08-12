import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/send_admin_notification.dart';

class FinalizeShopSignUp {
  final IShopAuthRepository repository;
  final SendAdminNotification sendAdminNotification;

  FinalizeShopSignUp(this.repository, this.sendAdminNotification);

  Future<void> call({
    required String ownerName,
    required String shopName,
    required String email,
  }) async {
    final shopId = await repository.finalizeSignUp(
      ownerName: ownerName,
      shopName: shopName,
      email: email,
    );
    // Send new shop registered notification to admin
    if (shopId != null) {
      try {
        await sendAdminNotification.sendNewShopRegistered(
          shopId: shopId,
          shopName: shopName,
        );
      } catch (_) {}
    }
  }
}
