import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class SendShopPasswordResetEmail {
  final IShopAuthRepository repository;

  SendShopPasswordResetEmail(this.repository);

  Future<void> call(String email) async {
    return await repository.sendPasswordResetEmail(email);
  }
}
