import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/admin/dashboard/domain/repositories/i_admin_dashboard_repository.dart';

class GetShopDetails {
  final IAdminDashboardRepository repository;

  const GetShopDetails(this.repository);

  Future<ShopProfileModel> call(String shopId) async {
    return await repository.getShopDetails(shopId);
  }
}
