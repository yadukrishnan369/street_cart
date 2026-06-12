enum ShopAppStatus {
  firstTime,
  notLoggedIn,
  profilePending,
  reviewPending,
  approved,
}

abstract class IShopSplashRepository {
  Future<ShopAppStatus> checkAppStatus();
}
