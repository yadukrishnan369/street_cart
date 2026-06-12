import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class SendShopEmailVerification {
  final IShopAuthRepository repository;

  SendShopEmailVerification(this.repository);

  Future<void> call() async {
    await repository.sendEmailVerification();
  }
}
