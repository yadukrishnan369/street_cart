import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class CheckShopEmailVerification {
  final IShopAuthRepository repository;

  CheckShopEmailVerification(this.repository);

  Future<bool> call() async {
    return await repository.checkEmailVerification();
  }
}
