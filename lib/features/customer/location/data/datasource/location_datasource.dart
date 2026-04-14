abstract class LocationDataSource {
  Future<bool> requestAndSave();
  Future<void> skip();
}
