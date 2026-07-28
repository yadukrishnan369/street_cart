import 'package:street_cart/features/admin/revenue/domain/repositories/i_admin_revenue_repository.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

/// Use case: fetch all orders from the revenue repository.
class GetRevenueOrders {
  final IAdminRevenueRepository repository;

  GetRevenueOrders(this.repository);

  Future<List<OrderModel>> call() => repository.getAllOrders();
}
