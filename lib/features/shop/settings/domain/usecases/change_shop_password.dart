import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class ChangeShopPassword {
  final IShopAuthRepository repository;

  ChangeShopPassword(this.repository);

  Future<void> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
