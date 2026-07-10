import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/data/datasources/i_admin_orders_remote_datasource.dart';
import 'package:street_cart/features/admin/orders/domain/repositories/i_admin_orders_repository.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class AdminOrdersRepositoryImpl implements IAdminOrdersRepository {
  final IAdminOrdersRemoteDataSource remoteDataSource;

  AdminOrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<OrderModel>> watchAllOrders() {
    return remoteDataSource.watchAllOrders();
  }

  @override
  Future<Map<String, String>> fetchShopNamesMap() {
    return remoteDataSource.fetchShopNamesMap();
  }

  @override
  Future<Map<String, ShopProfileModel>> fetchShopProfilesMap() {
    return remoteDataSource.fetchShopProfilesMap();
  }

  @override
  Future<Map<String, String>> fetchCustomerNamesMap() {
    return remoteDataSource.fetchCustomerNamesMap();
  }

  @override
  Future<Map<String, String>> fetchCustomerEmailsMap() {
    return remoteDataSource.fetchCustomerEmailsMap();
  }
}
