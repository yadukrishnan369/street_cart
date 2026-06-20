import 'package:street_cart/features/shop/home/data/datasource/shop_home_local_datasource.dart';
import 'package:street_cart/features/shop/home/domain/repositories/i_shop_home_repository.dart';

class ShopHomeRepositoryImpl implements IShopHomeRepository {
  final IShopHomeLocalDataSource _localDataSource;

  ShopHomeRepositoryImpl(this._localDataSource);

  @override
  Future<bool> isFirstHomeVisit() async {
    return await _localDataSource.isFirstHomeVisit();
  }

  @override
  Future<void> setFirstHomeVisitFalse() async {
    await _localDataSource.setFirstHomeVisitFalse();
  }
}
