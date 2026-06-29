import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'admin_product_remote_datasource.dart';

class AdminProductRemoteDataSourceImpl implements IAdminProductRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdminProductRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snap = await _firestore.collection('products').get();
      return snap.docs.map((doc) => ProductModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to get products from Firestore: $e');
    }
  }

  @override
  Future<List<ShopProfileModel>> getAllShops() async {
    try {
      final snap = await _firestore.collection('shops').get();
      return snap.docs.map((doc) => ShopProfileModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to get shops from Firestore: $e');
    }
  }

  @override
  Future<List<String>> getBusinessCategoryNames() async {
    try {
      final catDoc = await _firestore.collection('config').doc('categories').get();
      final List<String> categories = [];
      if (catDoc.exists && catDoc.data() != null) {
        final rawBusinessCats = catDoc.data()!['business_categories'] as List<dynamic>?;
        if (rawBusinessCats != null) {
          for (final e in rawBusinessCats) {
            final name = e['name'] as String?;
            if (name != null && name.isNotEmpty) {
              categories.add(name);
            }
          }
        }
      }
      return categories;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<String>> getProductCategoryNames() async {
    try {
      final catDoc = await _firestore.collection('config').doc('categories').get();
      final List<String> categories = [];
      if (catDoc.exists && catDoc.data() != null) {
        final rawProductCats = catDoc.data()!['product_categories'] as List<dynamic>?;
        if (rawProductCats != null) {
          for (final e in rawProductCats) {
            final name = e['name'] as String?;
            final isVisible = e['is_visible'] as bool? ?? true;
            if (name != null && name.isNotEmpty && isVisible) {
              categories.add(name);
            }
          }
        }
      }
      return categories;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> updateProductDisabledStatus(String productId, bool disabled) async {
    try {
      await _firestore.collection('products').doc(productId).update({
        'disabled_by_admin': disabled,
      });
    } catch (e) {
      throw Exception('Failed to update product disabled status: $e');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (!doc.exists) {
        throw Exception('Product not found');
      }
      return ProductModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to get product details: $e');
    }
  }

  @override
  Future<double> getPlatformCommission() async {
    try {
      final doc = await _firestore.collection('config').doc('settings').get();
      if (doc.exists && doc.data() != null) {
        return (doc.data()!['commission_percentage'] as num?)?.toDouble() ?? 2.0;
      }
      return 2.0;
    } catch (e) {
      return 2.0;
    }
  }
}
