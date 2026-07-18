import 'package:street_cart/features/customer/location/domain/repositories/i_location_repository.dart';
import 'package:street_cart/features/customer/location/data/datasource/location_datasource.dart';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';

class LocationRepositoryImpl implements ILocationRepository {
  final LocationDataSource dataSource;
  final INetworkInfo networkInfo;

  LocationRepositoryImpl({required this.dataSource, required this.networkInfo});

  @override
  Future<bool> requestAndSaveLocation() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return await dataSource.requestAndSave();
  }

  @override
  Future<void> skipLocation() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    await dataSource.skip();
  }
}
