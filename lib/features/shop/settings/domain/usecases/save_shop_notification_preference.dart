import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class SaveShopNotificationPreference {
  final IShopAuthRepository repository;

  SaveShopNotificationPreference(this.repository);

  Future<void> call(String key, bool value) async {
    await repository.saveNotificationPreference(key, value);
  }
}
