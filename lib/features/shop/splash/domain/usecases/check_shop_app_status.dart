import 'package:street_cart/features/shop/splash/domain/repositories/i_shop_splash_repository.dart';

class CheckShopAppStatus {
  final IShopSplashRepository repository;

  CheckShopAppStatus(this.repository);

  Future<ShopAppStatus> call() async {
    return await repository.checkAppStatus();
  }
}
