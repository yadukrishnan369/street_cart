import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/features/shop/home/data/datasource/shop_home_local_datasource.dart';

class ShopHomeLocalDataSourceImpl implements IShopHomeLocalDataSource {
  final SharedPreferences _sharedPreferences;
  static const String _key = 'isFirstHomeVisit';

  ShopHomeLocalDataSourceImpl(this._sharedPreferences);

  /// Saves Shops, visited the Home Page
  @override
  Future<void> setFirstHomeVisitFalse() async {
    await _sharedPreferences.setBool(_key, false);
  }

  // Check, the shop visited the home page First time or not
  @override
  Future<bool> isFirstHomeVisit() async {
    return _sharedPreferences.getBool(_key) ?? true;
  }
}
