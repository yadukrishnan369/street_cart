import 'package:street_cart/features/admin/revenue/domain/repositories/i_admin_revenue_repository.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class GetRevenueShops {
  final IAdminRevenueRepository repository;

  GetRevenueShops(this.repository);

  Future<List<ShopProfileModel>> call() => repository.getAllShops();
}
