import 'package:street_cart/features/admin/dashboard/domain/repositories/i_admin_dashboard_repository.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_shop_details.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/send_shop_notification.dart';

class ApproveShop {
  final IAdminDashboardRepository repository;
  final GetShopDetails getShopDetails;
  final SendShopNotification sendShopNotification;

  const ApproveShop({
    required this.repository,
    required this.getShopDetails,
    required this.sendShopNotification,
  });

  Future<void> call(String shopId) async {
    final shop = await getShopDetails(shopId);

    await repository.approveShop(shopId);

    try {
      // Send Approval/reject notification to shop
      await sendShopNotification.sendApprovalStatus(
        shopId: shopId,
        shopName: shop.shopName,
        approved: true,
      );
    } catch (_) {}
  }
}
