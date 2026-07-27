import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/sales_analytics/domain/repositories/i_sales_analytics_repository.dart';

class GetSalesAnalytics {
  final IShopSalesAnalyticsRepository repository;

  GetSalesAnalytics(this.repository);

  Future<(List<OrderModel>, List<ProductModel>)> call(String shopId) {
    return repository.getSalesAnalyticsData(shopId);
  }
}
