import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/data/datasources/i_admin_orders_remote_datasource.dart';
import 'package:street_cart/features/admin/orders/domain/repositories/i_admin_orders_repository.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class AdminOrdersRepositoryImpl implements IAdminOrdersRepository {
  final IAdminOrdersRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  AdminOrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<void> _checkConnection() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
  }

  @override
  Stream<List<OrderModel>> watchAllOrders() {
    return remoteDataSource.watchAllOrders();
  }

  @override
  Future<Map<String, String>> fetchShopNamesMap() async {
    await _checkConnection();
    return remoteDataSource.fetchShopNamesMap();
  }

  @override
  Future<Map<String, ShopProfileModel>> fetchShopProfilesMap() async {
    await _checkConnection();
    return remoteDataSource.fetchShopProfilesMap();
  }

  @override
  Future<Map<String, String>> fetchCustomerNamesMap() async {
    await _checkConnection();
    return remoteDataSource.fetchCustomerNamesMap();
  }

  @override
  Future<Map<String, String>> fetchCustomerEmailsMap() async {
    await _checkConnection();
    return remoteDataSource.fetchCustomerEmailsMap();
  }
}
