abstract class IShopLocationRepository {
  Future<bool> requestAndSaveLocation();
  Future<void> skipLocation();
}
