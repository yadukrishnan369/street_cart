abstract class IShopHomeRepository {
  Future<bool> isFirstHomeVisit();
  Future<void> setFirstHomeVisitFalse();
}
