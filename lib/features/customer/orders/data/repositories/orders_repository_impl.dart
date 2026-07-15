import 'package:street_cart/features/customer/orders/data/datasources/i_orders_remote_datasource.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/orders/domain/repositories/i_orders_repository.dart';

class OrdersRepositoryImpl implements IOrdersRepository {
  final IOrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<OrderModel>> getCustomerOrders() {
    try {
      return remoteDataSource.getCustomerOrders();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      await remoteDataSource.cancelOrder(orderId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> cancelOrderItem(String orderId, String orderItemId) async {
    try {
      await remoteDataSource.cancelOrderItem(orderId, orderItemId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateOrderAddress(String orderId, AddressModel address) async {
    try {
      await remoteDataSource.updateOrderAddress(orderId, address);
    } catch (e) {
      rethrow;
    }
  }
}
