import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/orders/data/datasources/i_orders_remote_datasource.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/orders/domain/repositories/i_orders_repository.dart';

class OrdersRepositoryImpl implements IOrdersRepository {
  final IOrdersRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Stream<List<OrderModel>> getCustomerOrders() async* {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    yield* remoteDataSource.getCustomerOrders();
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      await remoteDataSource.cancelOrder(orderId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> cancelOrderItem(String orderId, String orderItemId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      await remoteDataSource.cancelOrderItem(orderId, orderItemId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateOrderAddress(String orderId, AddressModel address) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      await remoteDataSource.updateOrderAddress(orderId, address);
    } catch (e) {
      rethrow;
    }
  }
}
