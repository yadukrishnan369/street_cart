import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/domain/repositories/i_shop_orders_repository.dart';

class GetShopDashboardOrders {
  final IShopOrdersRepository repository;

  GetShopDashboardOrders(this.repository);

  Stream<List<OrderModel>> call(String shopId) {
    return repository.watchShopOrders(shopId);
  }
}
