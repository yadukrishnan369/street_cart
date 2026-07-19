import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/features/shop/onboarding/data/datasource/shop_onboarding_local_datasource.dart';

class ShopOnboardingLocalDataSourceImpl
    implements IShopOnboardingLocalDataSource {
  final SharedPreferences _sharedPreferences;
  static const String _key = 'isFirstTimeShopOpen';

  ShopOnboardingLocalDataSourceImpl(this._sharedPreferences);

  // Saves to local, Shop completed the onboarding
  @override
  Future<void> setFirstTimeFalse() async {
    await _sharedPreferences.setBool(_key, false);
  }

  // Checks, if Shop is launching the application for first time
  @override
  Future<bool> isFirstTime() async {
    return _sharedPreferences.getBool(_key) ?? true;
  }
}
