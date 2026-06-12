abstract class IShopHomeLocalDataSource {
  Future<void> setFirstHomeVisitFalse();
  Future<bool> isFirstHomeVisit();
}
