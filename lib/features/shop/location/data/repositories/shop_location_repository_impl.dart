import 'package:street_cart/features/shop/location/domain/repositories/i_shop_location_repository.dart';
import 'package:street_cart/features/shop/location/data/datasource/shop_location_datasource.dart';

class ShopLocationRepositoryImpl implements IShopLocationRepository {
  final ShopLocationDataSource dataSource;

  ShopLocationRepositoryImpl({required this.dataSource});

  @override
  Future<bool> requestAndSaveLocation() async {
    return await dataSource.requestAndSave();
  }

  @override
  Future<void> skipLocation() async {
    await dataSource.skip();
  }
}
