import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/admin/revenue/data/datasources/i_admin_revenue_remote_datasource.dart';
import 'package:street_cart/features/admin/revenue/domain/repositories/i_admin_revenue_repository.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class AdminRevenueRepositoryImpl implements IAdminRevenueRepository {
  final IAdminRevenueRemoteDataSource _dataSource;
  final INetworkInfo _networkInfo;

  AdminRevenueRepositoryImpl({
    required IAdminRevenueRemoteDataSource dataSource,
    required INetworkInfo networkInfo,
  }) : _dataSource = dataSource,
       _networkInfo = networkInfo;

  Future<void> _checkConnection() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    await _checkConnection();
    try {
      return await _dataSource.getAllOrders();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ShopProfileModel>> getAllShops() async {
    await _checkConnection();
    try {
      return await _dataSource.getAllShops();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getAllProducts() async {
    await _checkConnection();
    try {
      return await _dataSource.getAllProducts();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CustomerModel>> getAllCustomers() async {
    await _checkConnection();
    try {
      return await _dataSource.getAllCustomers();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
