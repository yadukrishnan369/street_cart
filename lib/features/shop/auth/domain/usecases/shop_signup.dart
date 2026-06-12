import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class ShopSignup {
  final IShopAuthRepository repository;

  ShopSignup(this.repository);

  Future<void> call({
    required String email,
    required String password,
  }) async {
    return await repository.initiateSignUp(
      email: email,
      password: password,
    );
  }
}
