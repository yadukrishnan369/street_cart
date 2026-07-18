import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/products/data/datasources/customer_products_remote_datasource.dart';
import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class CustomerProductsRepositoryImpl implements ICustomerProductsRepository {
  final ICustomerProductsRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  CustomerProductsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<CustomerProductsData> getProductsData() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      final shops = await remoteDataSource.getNearbyShops();
      final products = await remoteDataSource.getNearbyProducts();
      return CustomerProductsData(products: products, shops: shops);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addToWishlist(
    ProductModel product,
    ShopProfileModel shop, {
    String? selectedColor,
    String? selectedSize,
  }) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      await remoteDataSource.addToWishlist(
        product,
        shop,
        selectedColor: selectedColor,
        selectedSize: selectedSize,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      await remoteDataSource.removeFromWishlist(productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<WishlistItem>> getWishlist() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      return await remoteDataSource.getWishlist();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearWishlist() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      await remoteDataSource.clearWishlist();
    } catch (e) {
      rethrow;
    }
  }
}
