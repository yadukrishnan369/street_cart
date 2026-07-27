import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class IShopSalesAnalyticsRepository {
  Future<(List<OrderModel>, List<ProductModel>)> getSalesAnalyticsData(
    String shopId,
  );
}
