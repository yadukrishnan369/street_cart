abstract class IShopOnboardingLocalDataSource {
  Future<void> setFirstTimeFalse();
  Future<bool> isFirstTime();
}
