import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class ShopLogout {
  final IShopAuthRepository repository;

  ShopLogout(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}
