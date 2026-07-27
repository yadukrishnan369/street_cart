import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/sales_analytics/data/datasources/sales_analytics_remote_datasource.dart';
import 'package:street_cart/features/shop/sales_analytics/domain/repositories/i_sales_analytics_repository.dart';

class ShopSalesAnalyticsRepositoryImpl
    implements IShopSalesAnalyticsRepository {
  final ISalesAnalyticsRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  ShopSalesAnalyticsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<(List<OrderModel>, List<ProductModel>)> getSalesAnalyticsData(
    String shopId,
  ) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    final orders = await remoteDataSource.getShopOrders(shopId);
    final products = await remoteDataSource.getShopProducts(shopId);
    return (orders, products);
  }
}
