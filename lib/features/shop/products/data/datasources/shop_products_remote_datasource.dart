import 'dart:io';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class IShopProductsRemoteDataSource {
  Stream<List<ProductModel>> getShopProducts(String shopId);
  Future<void> addProduct(ProductModel product, List<File> imageFiles);
  Future<void> updateProduct(ProductModel product, List<dynamic> imagesOrFiles);
  Future<void> deleteProduct(String shopId, String productId);
  Future<Map<String, dynamic>> getShopProductConfig(String shopId);
  Future<void> saveShopProductConfig(String shopId, Map<String, dynamic> config);
}
