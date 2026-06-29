import 'package:street_cart/features/customer/shops/domain/repositories/i_customer_shops_repository.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class GetNearbyShops {
  final ICustomerShopsRepository repository;

  GetNearbyShops({required this.repository});

  Future<List<ShopProfileModel>> call() async {
    return await repository.getNearbyShops();
  }
}
