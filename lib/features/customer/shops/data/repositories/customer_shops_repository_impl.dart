import 'package:street_cart/features/customer/shops/data/datasources/customer_shops_remote_datasource.dart';
import 'package:street_cart/features/customer/shops/domain/repositories/i_customer_shops_repository.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class CustomerShopsRepositoryImpl implements ICustomerShopsRepository {
  final ICustomerShopsRemoteDataSource remoteDataSource;

  CustomerShopsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ShopProfileModel>> getNearbyShops() async {
    try {
      return await remoteDataSource.getNearbyShops();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getShopProducts(String shopId) async {
    try {
      return await remoteDataSource.getShopProducts(shopId);
    } catch (e) {
      rethrow;
    }
  }
}
