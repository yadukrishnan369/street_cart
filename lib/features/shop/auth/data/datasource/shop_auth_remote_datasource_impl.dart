import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/core/firebase/firebase_auth_service.dart';
import 'package:street_cart/core/services/cloudinary_service.dart';
import 'package:street_cart/features/shop/auth/data/datasource/shop_auth_remote_datasource.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class ShopAuthRemoteDataSourceImpl implements IShopAuthRemoteDataSource {
  final FirebaseAuthService _authService;
  final FirebaseFirestore _firestore;
  final CloudinaryService _cloudinaryService;
  bool _isDeleting = false;

  ShopAuthRemoteDataSourceImpl({
    required FirebaseAuthService authService,
    required FirebaseFirestore firestore,
    required CloudinaryService cloudinaryService,
  })  : _authService = authService,
        _firestore = firestore,
        _cloudinaryService = cloudinaryService;

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      _isDeleting = false;
      await _authService.signUpWithEmail(email: email, password: password);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      _isDeleting = false;
      final userCredential = await _authService.signInWithEmail(email: email, password: password);
      final uid = userCredential.user?.uid;
      if (uid != null) {
        final doc = await _firestore.collection('shops').doc(uid).get();
        if (!doc.exists) {
          await _authService.signOut();
          throw ServerException('Access denied. You do not have a merchant account.');
        }
        final data = doc.data();
        if (data != null && data['is_suspended'] == true) {
          await _authService.signOut();
          throw ServerException('Your shop account is suspended. Please contact support.');
        }
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> finalizeSignUp({
    required String ownerName,
    required String shopName,
    required String email,
    required String userId,
  }) async {
    try {
      await _firestore.collection('shops').doc(userId).set({
        'owner_name': ownerName,
        'shop_name': shopName,
        'email': email,
        'role': 'shop',
        'is_approved': false,
        'is_profile_completed': false,
        'created_at': FieldValue.serverTimestamp(),
        'is_rejected': false,
        'rejection_reason': '',
        'is_reregistered': false,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> setupShopProfile({
    required String userId,
    required String category,
    required String description,
    required String gstNumber,
    required File businessLicenseFile,
    required File ownerIdFile,
  }) async {
    try {
      // Upload images to Cloudinary
      final licenseUrl = await _cloudinaryService.uploadImage(businessLicenseFile);
      final ownerIdUrl = await _cloudinaryService.uploadImage(ownerIdFile);

      if (licenseUrl == null || ownerIdUrl == null) {
        throw ServerException('Failed to upload documents. Please try again.');
      }

      final doc = await _firestore.collection('shops').doc(userId).get();
      final bool wasRejected = doc.exists && (doc.data()?['is_rejected'] == true);

      // Update Shop document
      await _firestore.collection('shops').doc(userId).update({
        'category': category,
        'description': description,
        'gst_number': gstNumber,
        'business_license_url': licenseUrl,
        'owner_id_url': ownerIdUrl,
        'is_profile_completed': true,
        'is_rejected': false,
        'rejection_reason': '',
        'is_reregistered': wasRejected ? true : (doc.data()?['is_reregistered'] ?? false),
        'is_approved': false,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<ShopProfileModel?> getShopStatus(String userId) {
    return _firestore
        .collection('shops')
        .doc(userId)
        .snapshots()
        .where((_) => !_isDeleting)
        .map((doc) => doc.exists ? ShopProfileModel.fromMap(doc.data()!, doc.id) : null);
  }

  @override
  Stream<String?> getAuthUserIdChanges() {
    return _authService.authStateChanges.map((user) => user?.uid);
  }

  @override
  Future<void> logout() async {
    await _authService.signOut();
  }

  @override
  Future<String?> getCurrentUserId() async {
    return _authService.getCurrentUserId();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Check if the email belongs to an admin
      final adminQuery = await _firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .get();
      
      bool isAdmin = adminQuery.docs.isNotEmpty;

      if (!isAdmin) {
        final userQuery = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        for (var doc in userQuery.docs) {
          final role = doc.data()['role'];
          if (role == 'admin' || role == 'super_admin') {
            isAdmin = true;
            break;
          }
        }
      }

      if (isAdmin) {
        throw ServerException('This email is registered as an another account.');
      }
    } catch (e) {
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('permission-denied') || errorStr.contains('permission denied') || errorStr.contains('insufficient permission')) {
        // If firestore rules block unauthenticated reads, fallback to direct firebase reset
        await _authService.sendPasswordResetEmail(email);
        return;
      }
      rethrow;
    }

    await _authService.sendPasswordResetEmail(email);
  }

  @override
  Future<void> sendEmailVerification() async {
    await _authService.sendEmailVerification();
  }

  @override
  Future<bool> checkEmailVerification() async {
    await _authService.reloadUser();
    return _authService.isEmailVerified();
  }

  @override
  Future<void> deleteAccount(String? password) async {
    try {
      _isDeleting = true;
      if (password != null) {
        await _authService.reauthenticate(password);
      }

      final uid = _authService.getCurrentUserId();
      if (uid == null) throw ServerException('No user logged in');

      // Delete Firestore data first while authenticated
      await _firestore.collection('shops').doc(uid).delete();

      // Then delete from Firebase Auth
      await _authService.deleteAuthAccount();

      // Sign out
      await _authService.signOut();
    } on ServerException {
      _isDeleting = false;
      rethrow;
    } catch (e) {
      _isDeleting = false;
      throw ServerException('An error occurred during account deletion: $e');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to change password: $e');
    }
  }

  @override
  Future<List<String>> getBusinessCategories() async {
    try {
      final doc = await _firestore.collection('config').doc('categories').get();
      if (doc.exists && doc.data() != null) {
        final rawBusinessCats = doc.data()!['business_categories'] as List<dynamic>?;
        if (rawBusinessCats != null) {
          return rawBusinessCats
              .map((e) => Map<String, dynamic>.from(e as Map))
              .where((e) => e['is_visible'] == true)
              .map((e) => e['name'] as String)
              .where((name) => name.isNotEmpty)
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw ServerException('Failed to load business categories: $e');
    }
  }

  @override
  Future<Map<String, bool>> getPaymentSettings() async {
    try {
      final doc = await _firestore.collection('config').doc('settings').get();
      if (doc.exists && doc.data() != null) {
        return {
          'enable_cod': doc.data()!['enable_cod'] ?? true,
          'enable_online': doc.data()!['enable_online'] ?? true,
        };
      }
      return {
        'enable_cod': true,
        'enable_online': true,
      };
    } catch (e) {
      throw ServerException('Failed to load payment settings: $e');
    }
  }
}
