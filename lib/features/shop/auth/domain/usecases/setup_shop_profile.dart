import 'dart:io';
import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/send_admin_notification.dart';

class SetupShopProfile {
  final IShopAuthRepository repository;
  final SendAdminNotification sendAdminNotification;

  SetupShopProfile(this.repository, this.sendAdminNotification);

  Future<void> call({
    required String category,
    required String description,
    required String gstNumber,
    required File businessLicenseFile,
    required File ownerIdFile,
  }) async {
    final result = await repository.setupShopProfile(
      category: category,
      description: description,
      gstNumber: gstNumber,
      businessLicenseFile: businessLicenseFile,
      ownerIdFile: ownerIdFile,
    );

    final String userId = result['userId'] ?? '';
    final String shopName = result['shopName'] ?? 'Shop';
    final bool wasRejected = result['wasRejected'] ?? false;

    try {
      // Send profile resubmitted notification to shop
      if (wasRejected) {
        await sendAdminNotification.sendShopResubmitted(
          shopId: userId,
          shopName: shopName,
        );
        // Send profile completed notification to shop
      } else {
        await sendAdminNotification.sendShopProfileCompleted(
          shopId: userId,
          shopName: shopName,
        );
      }
    } catch (_) {}
  }
}
