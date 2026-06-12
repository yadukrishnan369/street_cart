import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class IShopSplashRemoteDataSource {
  Future<bool> isUserLoggedIn();
  Future<ShopProfileModel?> getShopProfile(String userId);
  String? getCurrentUserId();
}
