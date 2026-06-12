import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class GetShopStatus {
  final IShopAuthRepository repository;

  GetShopStatus(this.repository);

  Stream<ShopProfileModel?> call() {
    return repository.getShopStatus();
  }
}
