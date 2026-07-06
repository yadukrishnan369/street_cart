import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_local_datasource.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_remote_datasource.dart';
import 'package:street_cart/features/shop/splash/domain/repositories/i_shop_splash_repository.dart';

class ShopSplashRepositoryImpl implements IShopSplashRepository {
  final IShopSplashLocalDataSource local;
  final IShopSplashRemoteDataSource remote;

  ShopSplashRepositoryImpl({required this.local, required this.remote});

  @override
  Future<ShopAppStatus> checkAppStatus() async {
    try {
      final isFirstTime = await local.isFirstTime();
      if (isFirstTime) return ShopAppStatus.firstTime;

      final isLoggedIn = await remote.isUserLoggedIn();
      if (!isLoggedIn) return ShopAppStatus.notLoggedIn;

      final userId = remote.getCurrentUserId();
      if (userId == null) return ShopAppStatus.notLoggedIn;

      final shopProfile = await remote.getShopProfile(userId);
      if (shopProfile == null) return ShopAppStatus.notLoggedIn;

      if (!shopProfile.isProfileCompleted) return ShopAppStatus.profilePending;
      if (!shopProfile.isApproved) return ShopAppStatus.reviewPending;

      return ShopAppStatus.approved;
    } catch (e) {
      // Return notLoggedIn on any exception, network timeout or permission denied due to role mismatch)
      return ShopAppStatus.notLoggedIn;
    }
  }
}
