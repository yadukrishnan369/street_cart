import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/admin/revenue/domain/repositories/i_admin_revenue_repository.dart';

/// Use case: fetch all customers from the revenue repository.
class GetRevenueCustomers {
  final IAdminRevenueRepository repository;

  GetRevenueCustomers(this.repository);

  Future<List<CustomerModel>> call() => repository.getAllCustomers();
}
