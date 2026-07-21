import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/admin/shops/data/datasources/i_admin_shop_remote_datasource.dart';

class AdminShopRemoteDataSourceImpl implements IAdminShopRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdminShopRemoteDataSourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  // Delete the Shop Account
  @override
  Future<void> deleteShop(String shopId) async {
    try {
      await _firestore.collection('shops').doc(shopId).delete();
      await _firestore.collection('users').doc(shopId).delete();
    } catch (e) {
      throw Exception('Failed to delete shop from Firestore: $e');
    }
  }

  // Fetch a single shop profile ID
  @override
  Future<ShopProfileModel> getShopById(String shopId) async {
    try {
      final doc = await _firestore.collection('shops').doc(shopId).get();
      if (!doc.exists || doc.data() == null) {
        throw Exception('Shop not found');
      }
      return ShopProfileModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Failed to get shop details: $e');
    }
  }

  // Get all Approved Shops
  @override
  Future<List<ShopProfileModel>> getAllApprovedShops() async {
    try {
      final snap = await _firestore
          .collection('shops')
          .where('is_approved', isEqualTo: true)
          .get();

      return snap.docs.map((doc) {
        return ShopProfileModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get approved shops from Firestore: $e');
    }
  }

  // Update Shop Suspension Status
  @override
  Future<void> updateShopSuspensionStatus(
    String shopId,
    bool isSuspended,
  ) async {
    try {
      await _firestore.collection('shops').doc(shopId).update({
        'is_suspended': isSuspended,
      });
    } catch (e) {
      throw Exception('Failed to update shop suspension status: $e');
    }
  }

  // Get the business category names
  @override
  Future<List<String>> getBusinessCategoryNames() async {
    try {
      final catDoc = await _firestore
          .collection('config')
          .doc('categories')
          .get();
      final List<String> categories = [];
      if (catDoc.exists && catDoc.data() != null) {
        final rawBusinessCats =
            catDoc.data()!['business_categories'] as List<dynamic>?;
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

  // Fetch all Products belonging to the Shop
  @override
  Future<List<ProductModel>> getProductsByShopId(String shopId) async {
    try {
      final snap = await _firestore
          .collection('products')
          .where('shop_id', isEqualTo: shopId)
          .get();
      final products = snap.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();

      // Sort newest first
      products.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
      return products;
    } catch (e) {
      throw Exception('Failed to get products for shop: $e');
    }
  }
}
