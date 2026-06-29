import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/core/services/cloudinary_service.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'shop_products_remote_datasource.dart';

class ShopProductsRemoteDataSourceImpl implements IShopProductsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final CloudinaryService _cloudinaryService;

  ShopProductsRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required CloudinaryService cloudinaryService,
  })  : _firestore = firestore,
        _cloudinaryService = cloudinaryService;

  @override
  Stream<List<ProductModel>> getShopProducts(String shopId) {
    return _firestore
        .collection('products')
        .where('shop_id', isEqualTo: shopId)
        .snapshots()
        .map((snapshot) {
      final products = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
      // Sort by createdAt descending
      products.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return -1;
        if (b.createdAt == null) return 1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      return products;
    });
  }

  @override
  Future<void> addProduct(ProductModel product, List<File> imageFiles) async {
    try {
      final List<String> imageUrls = [];
      for (final file in imageFiles) {
        final url = await _cloudinaryService.uploadImage(file);
        if (url != null) {
          imageUrls.add(url);
        }
      }
      final newProduct = product.copyWith(images: imageUrls);
      await _firestore
          .collection('products')
          .add(newProduct.toMap());
    } catch (e) {
      throw ServerException('Failed to add product: $e');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product, List<dynamic> imagesOrFiles) async {
    try {
      final List<String> imageUrls = [];
      for (final item in imagesOrFiles) {
        if (item is String) {
          imageUrls.add(item);
        } else if (item is File) {
          final url = await _cloudinaryService.uploadImage(item);
          if (url != null) {
            imageUrls.add(url);
          }
        }
      }
      final updatedProduct = product.copyWith(images: imageUrls);
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(updatedProduct.toMap());
    } catch (e) {
      throw ServerException('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String shopId, String productId) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .delete();
    } catch (e) {
      throw ServerException('Failed to delete product: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getShopProductConfig(String shopId) async {
    try {
      final doc = await _firestore
          .collection('shops')
          .doc(shopId)
          .collection('config')
          .doc('products_config')
          .get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!;
      }
      return {};
    } catch (e) {
      throw ServerException('Failed to fetch shop product config: $e');
    }
  }

  @override
  Future<void> saveShopProductConfig(String shopId, Map<String, dynamic> config) async {
    try {
      await _firestore
          .collection('shops')
          .doc(shopId)
          .collection('config')
          .doc('products_config')
          .set(config, SetOptions(merge: true));
    } catch (e) {
      throw ServerException('Failed to save shop product config: $e');
    }
  }
}
