import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/data/datasources/i_shop_orders_remote_datasource.dart';
import 'package:street_cart/features/shop/orders/domain/repositories/i_shop_orders_repository.dart';

class ShopOrdersRepositoryImpl implements IShopOrdersRepository {
  final IShopOrdersRemoteDataSource remoteDataSource;

  ShopOrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<OrderModel>> watchShopOrders(String shopId) {
    return remoteDataSource.watchShopOrders(shopId);
  }

  @override
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await remoteDataSource.updateOrderStatus(orderId, newStatus);
    } catch (e) {
      rethrow;
    }
  }
}
