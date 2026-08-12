import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class GetShopNotificationPreferences {
  final IShopAuthRepository repository;

  GetShopNotificationPreferences(this.repository);

  Future<Map<String, bool>> call() async {
    return await repository.getNotificationPreferences();
  }
}
