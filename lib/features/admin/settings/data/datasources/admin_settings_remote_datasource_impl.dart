import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/firebase/firebase_auth_service.dart';
import 'package:street_cart/features/admin/settings/data/models/admin_settings_model.dart';
import 'admin_settings_remote_datasource.dart';

class AdminSettingsRemoteDataSourceImpl
    implements IAdminSettingsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuthService _authService;

  AdminSettingsRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuthService authService,
  }) : _firestore = firestore,
       _authService = authService;
  // Get Settings Data
  @override
  Future<AdminSettingsModel> getSettings() async {
    final Map<String, dynamic> data = {};

    try {
      final doc = await _firestore.collection('config').doc('settings').get();
      if (doc.exists && doc.data() != null) {
        data.addAll(doc.data()!);
      }
    } catch (e) {
      // Gracefully handle failure
    }

    try {
      final catDoc = await _firestore
          .collection('config')
          .doc('categories')
          .get();
      if (catDoc.exists && catDoc.data() != null) {
        data.addAll(catDoc.data()!);
      }
    } catch (e) {
      // Gracefully handle failure
    }

    try {
      if (data.isNotEmpty) {
        return AdminSettingsModel.fromMap(data);
      }

      // Return defaults if document doesn't exist
      return const AdminSettingsModel(
        commissionPercentage: 2.0,
        enableCod: true,
        enableOnline: true,
        productCategories: [],
        businessCategories: [],
      );
    } catch (e) {
      throw Exception('Failed to load admin settings: $e');
    }
  }

  // Save Platform Commission
  @override
  Future<List<String>> savePlatformCommission(double percentage) async {
    try {
      await _firestore.collection('config').doc('settings').set({
        'commission_percentage': percentage,
      }, SetOptions(merge: true));

      final shopsSnap = await _firestore.collection('shops').get();
      return shopsSnap.docs.map((doc) => doc.id).toList();
    } catch (e) {
      throw Exception('Failed to save platform commission: $e');
    }
  }

  // Save Payment Controls
  @override
  Future<void> savePaymentControls({
    required bool enableCod,
    required bool enableOnline,
  }) async {
    try {
      await _firestore.collection('config').doc('settings').set({
        'enable_cod': enableCod,
        'enable_online': enableOnline,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save payment controls: $e');
    }
  }

  // Change Admin Password
  @override
  Future<void> changeAdminPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      if (errorMsg.contains('Incorrect email or password') ||
          errorMsg.contains('invalid-credential') ||
          errorMsg.contains('wrong-password')) {
        throw Exception('Incorrect current password.');
      }
      throw Exception(errorMsg);
    }
  }

  // Save Categories
  @override
  Future<void> saveCategories({
    required List<CategoryModel> productCategories,
    required List<CategoryModel> businessCategories,
  }) async {
    try {
      await _firestore.collection('config').doc('categories').set({
        'product_categories': productCategories.map((e) => e.toMap()).toList(),
        'business_categories': businessCategories
            .map((e) => e.toMap())
            .toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save categories: $e');
    }
  }

  // Get Product Config
  @override
  Future<ProductConfigModel> getProductConfig() async {
    try {
      final doc = await _firestore
          .collection('config')
          .doc('product_config')
          .get();
      if (doc.exists && doc.data() != null) {
        return ProductConfigModel.fromMap(doc.data()!);
      }
      return const ProductConfigModel();
    } catch (e) {
      throw Exception('Failed to load product config: $e');
    }
  }

  // Save Colors
  @override
  Future<void> saveColors(List<ColorModel> colors) async {
    try {
      await _firestore.collection('config').doc('product_config').set({
        'colors': colors.map((e) => e.toMap()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save colors: $e');
    }
  }

  // Save Size Groups
  @override
  Future<void> saveSizeGroups(List<SizeGroupModel> sizeGroups) async {
    try {
      await _firestore.collection('config').doc('product_config').set({
        'size_groups': sizeGroups.map((e) => e.toMap()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save size groups: $e');
    }
  }

  // Get Notification Preferences
  @override
  Future<Map<String, bool>> getNotificationPreferences() async {
    try {
      final uid = await _authService.getCurrentUserIdAsync();
      if (uid != null) {
        final doc = await _firestore.collection('admins').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          final data = doc.data()!;
          return {
            'registrationAlertsEnabled':
                data['registrationAlertsEnabled'] ?? true,
            'orderAlertsEnabled': data['orderAlertsEnabled'] ?? true,
          };
        }
      }
      return {'registrationAlertsEnabled': true, 'orderAlertsEnabled': true};
    } catch (e) {
      throw Exception('Failed to load notification preferences: $e');
    }
  }

  // Save Notification Preference
  @override
  Future<void> saveNotificationPreference(String key, bool value) async {
    try {
      final uid = await _authService.getCurrentUserIdAsync();
      if (uid != null) {
        await _firestore.collection('admins').doc(uid).set({
          key: value,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception('Failed to save notification preference: $e');
    }
  }
}
