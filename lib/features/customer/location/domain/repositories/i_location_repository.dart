abstract class ILocationRepository {
  Future<bool> requestAndSaveLocation();
  Future<void> skipLocation();
}