import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class FinalizeShopSignUp {
  final IShopAuthRepository repository;

  FinalizeShopSignUp(this.repository);

  Future<void> call({
    required String ownerName,
    required String shopName,
    required String email,
  }) async {
    await repository.finalizeSignUp(
      ownerName: ownerName,
      shopName: shopName,
      email: email,
    );
  }
}
