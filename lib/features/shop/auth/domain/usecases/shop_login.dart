import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class ShopLogin {
  final IShopAuthRepository repository;

  ShopLogin(this.repository);

  Future<void> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(
      email: email,
      password: password,
    );
  }
}
