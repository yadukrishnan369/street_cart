import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class GetShopPaymentSettings {
  final IShopAuthRepository _repository;

  GetShopPaymentSettings(this._repository);

  Future<Map<String, bool>> call() async {
    return await _repository.getPaymentSettings();
  }
}
