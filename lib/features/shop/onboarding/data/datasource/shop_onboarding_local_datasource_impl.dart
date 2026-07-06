import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/features/shop/onboarding/data/datasource/shop_onboarding_local_datasource.dart';

class ShopOnboardingLocalDataSourceImpl
    implements IShopOnboardingLocalDataSource {
  final SharedPreferences _sharedPreferences;
  static const String _key = 'isFirstTimeShopOpen';

  ShopOnboardingLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<void> setFirstTimeFalse() async {
    await _sharedPreferences.setBool(_key, false);
  }

  @override
  Future<bool> isFirstTime() async {
    return _sharedPreferences.getBool(_key) ?? true;
  }
}
