import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class IAdminShopRemoteDataSource {
  Future<List<ShopProfileModel>> getAllApprovedShops();
  Future<void> updateShopSuspensionStatus(String shopId, bool isSuspended);
  Future<List<String>> getBusinessCategoryNames();
  Future<ShopProfileModel> getShopById(String shopId);
  Future<void> deleteShop(String shopId);
}

class AdminShopRemoteDataSourceImpl implements IAdminShopRemoteDataSource {
  final FirebaseFirestore _firestore;

  AdminShopRemoteDataSourceImpl({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<void> deleteShop(String shopId) async {
    try {
      await _firestore.collection('shops').doc(shopId).delete();
      await _firestore.collection('users').doc(shopId).delete();
    } catch (e) {
      throw Exception('Failed to delete shop from Firestore: $e');
    }
  }

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

  @override
  Future<void> updateShopSuspensionStatus(String shopId, bool isSuspended) async {
    try {
      await _firestore.collection('shops').doc(shopId).update({
        'is_suspended': isSuspended,
      });
    } catch (e) {
      throw Exception('Failed to update shop suspension status: $e');
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
}
