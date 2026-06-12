import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_local_datasource.dart';

class ShopSplashLocalDataSourceImpl implements IShopSplashLocalDataSource {
  final SharedPreferences sharedPreferences;

  ShopSplashLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<bool> isFirstTime() async {
    return sharedPreferences.getBool('isFirstTimeShopOpen') ?? true;
  }
}
