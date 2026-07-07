import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/cart/domain/repositories/i_cart_repository.dart';
import 'package:street_cart/features/customer/cart/data/datasources/cart_remote_datasource.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class CartRepositoryImpl implements ICartRepository {
  final ICartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CartItem>> getCartItems() async {
    try {
      return await remoteDataSource.getCartItems();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addToCart(CartItem item) async {
    try {
      await remoteDataSource.addToCart(item);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    try {
      await remoteDataSource.removeFromCart(itemId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateQuantity(String itemId, int quantity) async {
    try {
      await remoteDataSource.updateQuantity(itemId, quantity);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await remoteDataSource.clearCart();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    try {
      return await remoteDataSource.getProductById(productId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ShopProfileModel> getShopById(String shopId) async {
    try {
      return await remoteDataSource.getShopById(shopId);
    } catch (e) {
      rethrow;
    }
  }
}
