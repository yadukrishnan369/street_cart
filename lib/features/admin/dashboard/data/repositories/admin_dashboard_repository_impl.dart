import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import '../models/dashboard_stats_model.dart';
import '../models/new_registration_model.dart';
import '../../domain/repositories/i_admin_dashboard_repository.dart';
import '../datasources/admin_dashboard_remote_datasource.dart';

class AdminDashboardRepositoryImpl implements IAdminDashboardRepository {
  final IAdminDashboardRemoteDataSource remoteDataSource;

  AdminDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    return await remoteDataSource.getDashboardStats();
  }

  @override
  Future<List<NewRegistrationModel>> getPendingRegistrations({required int page, required int limit}) async {
    return await remoteDataSource.getPendingRegistrations(page: page, limit: limit);
  }

  @override
  Future<int> getPendingRegistrationsCount() async {
    return await remoteDataSource.getPendingRegistrationsCount();
  }

  @override
  Future<ShopProfileModel> getShopDetails(String shopId) async {
    return await remoteDataSource.getShopDetails(shopId);
  }

  @override
  Future<void> approveShop(String shopId) async {
    return await remoteDataSource.approveShop(shopId);
  }

  @override
  Future<void> rejectShop(String shopId) async {
    return await remoteDataSource.rejectShop(shopId);
  }
}
