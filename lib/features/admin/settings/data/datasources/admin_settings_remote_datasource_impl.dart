import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/firebase/firebase_auth_service.dart';
import '../models/admin_settings_model.dart';
import 'admin_settings_remote_datasource.dart';

class AdminSettingsRemoteDataSourceImpl implements IAdminSettingsRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuthService _authService;

  AdminSettingsRemoteDataSourceImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuthService authService,
  })  : _firestore = firestore,
        _authService = authService;

  @override
  Future<AdminSettingsModel> getSettings() async {
    final Map<String, dynamic> data = {};
    
    try {
      final doc = await _firestore.collection('config').doc('settings').get();
      if (doc.exists && doc.data() != null) {
        data.addAll(doc.data()!);
      }
    } catch (e) {
      // Gracefully log or handle settings doc read failure
    }

    try {
      final catDoc = await _firestore.collection('config').doc('categories').get();
      if (catDoc.exists && catDoc.data() != null) {
        data.addAll(catDoc.data()!);
      }
    } catch (e) {
      // Gracefully log or ignore categories doc read failure to avoid breaking settings page
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

  @override
  Future<void> savePlatformCommission(double percentage) async {
    try {
      await _firestore.collection('config').doc('settings').set({
        'commission_percentage': percentage,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save platform commission: $e');
    }
  }

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
      if (errorMsg.contains('Incorrect email or password') || errorMsg.contains('invalid-credential') || errorMsg.contains('wrong-password')) {
        throw Exception('Incorrect current password.');
      }
      throw Exception(errorMsg);
    }
  }

  @override
  Future<void> saveCategories({
    required List<CategoryModel> productCategories,
    required List<CategoryModel> businessCategories,
  }) async {
    try {
      await _firestore.collection('config').doc('categories').set({
        'product_categories': productCategories.map((e) => e.toMap()).toList(),
        'business_categories': businessCategories.map((e) => e.toMap()).toList(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save categories: $e');
    }
  }
}
