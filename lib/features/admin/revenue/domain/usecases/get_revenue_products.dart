import 'package:street_cart/features/admin/revenue/domain/repositories/i_admin_revenue_repository.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class GetRevenueProducts {
  final IAdminRevenueRepository repository;

  GetRevenueProducts(this.repository);

  Future<List<ProductModel>> call() => repository.getAllProducts();
}
