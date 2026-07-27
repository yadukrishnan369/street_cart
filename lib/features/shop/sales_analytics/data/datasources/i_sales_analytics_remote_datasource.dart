import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class ISalesAnalyticsRemoteDataSource {
  Future<List<OrderModel>> getShopOrders(String shopId);
  Future<List<ProductModel>> getShopProducts(String shopId);
}
