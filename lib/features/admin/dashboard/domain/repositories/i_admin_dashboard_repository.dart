import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../data/models/new_registration_model.dart';

abstract class IAdminDashboardRepository {
  Future<DashboardStatsModel> getDashboardStats();
  Future<List<NewRegistrationModel>> getPendingRegistrations({required int page, required int limit});
  Future<int> getPendingRegistrationsCount();
  Future<ShopProfileModel> getShopDetails(String shopId);
  Future<void> approveShop(String shopId);
  Future<void> rejectShop(String shopId, String rejectionReason);
}
