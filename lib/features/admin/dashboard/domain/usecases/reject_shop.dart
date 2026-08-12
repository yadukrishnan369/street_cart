import 'package:street_cart/features/admin/dashboard/domain/repositories/i_admin_dashboard_repository.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_shop_details.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/send_shop_notification.dart';

class RejectShop {
  final IAdminDashboardRepository repository;
  final GetShopDetails getShopDetails;
  final SendShopNotification sendShopNotification;

  const RejectShop({
    required this.repository,
    required this.getShopDetails,
    required this.sendShopNotification,
  });

  Future<void> call(String shopId, String rejectionReason) async {
    String shopName = shopId;
    try {
      final shop = await getShopDetails(shopId);
      shopName = shop.shopName;
    } catch (_) {}

    await repository.rejectShop(shopId, rejectionReason);

    try {
      // Send Approval/reject notification to shop
      await sendShopNotification.sendApprovalStatus(
        shopId: shopId,
        shopName: shopName,
        approved: false,
        rejectionReason: rejectionReason,
      );
    } catch (_) {}
  }
}
