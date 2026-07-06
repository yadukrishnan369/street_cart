import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/features/shop/products/data/datasources/shop_products_remote_datasource.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/data/models/variant_image_draft.dart';
import 'package:street_cart/features/shop/products/domain/repositories/i_shop_products_repository.dart';

class ShopProductsRepositoryImpl implements IShopProductsRepository {
  final IShopProductsRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  ShopProductsRepositoryImpl({
    required IShopProductsRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Stream<List<ProductModel>> getShopProducts(String shopId) {
    return _remoteDataSource.getShopProducts(shopId);
  }

  @override
  Future<void> addProduct(
    ProductModel product,
    List<VariantImageDraft> variantDrafts,
  ) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection. Please check your network.');
    }
    await _remoteDataSource.addProduct(product, variantDrafts);
  }

  @override
  Future<void> updateProduct(
    ProductModel product,
    List<VariantImageDraft> variantDrafts,
  ) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection. Please check your network.');
    }
    await _remoteDataSource.updateProduct(product, variantDrafts);
  }

  @override
  Future<void> deleteProduct(String shopId, String productId) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection. Please check your network.');
    }
    await _remoteDataSource.deleteProduct(shopId, productId);
  }

  @override
  Future<Map<String, dynamic>> getShopProductConfig(String shopId) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection. Please check your network.');
    }
    return await _remoteDataSource.getShopProductConfig(shopId);
  }

  @override
  Future<void> saveShopProductConfig(
      String shopId, Map<String, dynamic> config) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection. Please check your network.');
    }
    await _remoteDataSource.saveShopProductConfig(shopId, config);
  }
}
