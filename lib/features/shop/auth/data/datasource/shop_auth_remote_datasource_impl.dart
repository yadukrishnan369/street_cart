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
      await _authService.signInWithEmail(email: email, password: password);
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
      // 1. Upload images to Cloudinary
      final licenseUrl = await _cloudinaryService.uploadImage(businessLicenseFile);
      final ownerIdUrl = await _cloudinaryService.uploadImage(ownerIdFile);

      if (licenseUrl == null || ownerIdUrl == null) {
        throw ServerException('Failed to upload documents. Please try again.');
      }

      // 2. Update Shop document
      await _firestore.collection('shops').doc(userId).update({
        'category': category,
        'description': description,
        'gst_number': gstNumber,
        'business_license_url': licenseUrl,
        'owner_id_url': ownerIdUrl,
        'is_profile_completed': true,
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
        .map((doc) => doc.exists ? ShopProfileModel.fromMap(doc.data()!, doc.id) : null);
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
      if (password != null) {
        await _authService.reauthenticate(password);
      }

      final uid = _authService.getCurrentUserId();
      if (uid == null) throw ServerException('No user logged in');

      // Delete Firestore data (if any was created)
      await _firestore.collection('shops').doc(uid).delete();

      // Delete from Firebase Auth
      await _authService.deleteAuthAccount();

      // Sign out
      await _authService.signOut();
    } on ServerException {
      rethrow;
    } catch (e) {
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
}
