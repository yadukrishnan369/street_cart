import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/admin/dashboard/data/models/dashboard_stats_model.dart';
import 'package:street_cart/features/admin/dashboard/data/models/new_registration_model.dart';
import 'package:street_cart/features/admin/dashboard/domain/repositories/i_admin_dashboard_repository.dart';
import 'package:street_cart/features/admin/dashboard/data/datasources/admin_dashboard_remote_datasource.dart';

class AdminDashboardRepositoryImpl implements IAdminDashboardRepository {
  final IAdminDashboardRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  AdminDashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<void> _checkConnection() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
  }

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    await _checkConnection();
    return await remoteDataSource.getDashboardStats();
  }

  @override
  Future<List<NewRegistrationModel>> getPendingRegistrations({
    required int page,
    required int limit,
  }) async {
    await _checkConnection();
    return await remoteDataSource.getPendingRegistrations(
      page: page,
      limit: limit,
    );
  }

  @override
  Future<int> getPendingRegistrationsCount() async {
    await _checkConnection();
    return await remoteDataSource.getPendingRegistrationsCount();
  }

  @override
  Future<ShopProfileModel> getShopDetails(String shopId) async {
    await _checkConnection();
    return await remoteDataSource.getShopDetails(shopId);
  }

  @override
  Future<void> approveShop(String shopId) async {
    await _checkConnection();
    return await remoteDataSource.approveShop(shopId);
  }

  @override
  Future<void> rejectShop(String shopId, String rejectionReason) async {
    await _checkConnection();
    return await remoteDataSource.rejectShop(shopId, rejectionReason);
  }
}
