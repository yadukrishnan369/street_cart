import 'package:street_cart/features/customer/location/domain/repositories/i_location_repository.dart';

class RequestLocationAndSave {
  final ILocationRepository repository;

  RequestLocationAndSave(this.repository);

  Future<bool> call() async {
    return await repository.requestAndSaveLocation();
  }
}

class SkipLocation {
  final ILocationRepository repository;

  SkipLocation(this.repository);

  Future<void> call() async {
    await repository.skipLocation();
  }
}
