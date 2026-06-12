import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class DeleteShopAuthAccount {
  final IShopAuthRepository repository;

  DeleteShopAuthAccount(this.repository);

  Future<void> call(String? password) async {
    await repository.deleteAccount(password);
  }
}
