import 'package:street_cart/features/shop/location/domain/repositories/i_shop_location_repository.dart';

class RequestShopLocationAndSave {
  final IShopLocationRepository repository;

  RequestShopLocationAndSave(this.repository);

  Future<bool> call() async {
    return await repository.requestAndSaveLocation();
  }
}

class SkipShopLocation {
  final IShopLocationRepository repository;

  SkipShopLocation(this.repository);

  Future<void> call() async {
    await repository.skipLocation();
  }
}
