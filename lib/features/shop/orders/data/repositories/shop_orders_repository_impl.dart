import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/data/datasources/i_shop_orders_remote_datasource.dart';
import 'package:street_cart/features/shop/orders/domain/repositories/i_shop_orders_repository.dart';

class ShopOrdersRepositoryImpl implements IShopOrdersRepository {
  final IShopOrdersRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  ShopOrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Stream<List<OrderModel>> watchShopOrders(String shopId) async* {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    yield* remoteDataSource.watchShopOrders(shopId);
  }

  @override
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      await remoteDataSource.updateOrderStatus(orderId, newStatus);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateReturnStatus(
    String orderId,
    String returnStatus, {
    bool refundViaHand = false,
    double refundAmount = 0.0,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      await remoteDataSource.updateReturnStatus(
        orderId,
        returnStatus,
        refundViaHand: refundViaHand,
        refundAmount: refundAmount,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> processRefund(
    String orderId,
    double refundAmount,
    String refundStatus,
  ) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      await remoteDataSource.processRefund(orderId, refundAmount, refundStatus);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, Map<String, bool>>> checkProductsStatus(
    List<String> productIds,
  ) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      return await remoteDataSource.checkProductsStatus(productIds);
    } catch (e) {
      rethrow;
    }
  }
}
