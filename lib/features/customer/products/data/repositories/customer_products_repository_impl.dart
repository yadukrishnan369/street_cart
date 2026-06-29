import 'package:street_cart/features/customer/products/data/datasources/customer_products_remote_datasource.dart';
import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class CustomerProductsRepositoryImpl implements ICustomerProductsRepository {
  final ICustomerProductsRemoteDataSource remoteDataSource;

  CustomerProductsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CustomerProductsData> getProductsData() async {
    try {
      final shops = await remoteDataSource.getNearbyShops();
      final products = await remoteDataSource.getNearbyProducts();
      return CustomerProductsData(products: products, shops: shops);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addToWishlist(ProductModel product, ShopProfileModel shop) async {
    try {
      await remoteDataSource.addToWishlist(product, shop);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    try {
      await remoteDataSource.removeFromWishlist(productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<WishlistItem>> getWishlist() async {
    try {
      return await remoteDataSource.getWishlist();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearWishlist() async {
    try {
      await remoteDataSource.clearWishlist();
    } catch (e) {
      rethrow;
    }
  }
}
