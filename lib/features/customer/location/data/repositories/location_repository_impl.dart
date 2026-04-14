import 'package:street_cart/features/customer/location/domain/repositories/i_location_repository.dart';
import 'package:street_cart/features/customer/location/data/datasource/location_datasource.dart';

class LocationRepositoryImpl implements ILocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl({required this.dataSource});

  @override
  Future<bool> requestAndSaveLocation() async {
    return await dataSource.requestAndSave();
  }

  @override
  Future<void> skipLocation() async {
    await dataSource.skip();
  }
}
