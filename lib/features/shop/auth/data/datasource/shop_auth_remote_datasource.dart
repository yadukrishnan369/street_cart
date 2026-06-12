import 'dart:io';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class IShopAuthRemoteDataSource {
  Future<void> signUp({
    required String email,
    required String password,
  });

  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> finalizeSignUp({
    required String ownerName,
    required String shopName,
    required String email,
    required String userId,
  });

  Future<void> setupShopProfile({
    required String userId,
    required String category,
    required String description,
    required String gstNumber,
    required File businessLicenseFile,
    required File ownerIdFile,
  });

  Stream<ShopProfileModel?> getShopStatus(String userId);

  Future<void> logout();

  Future<String?> getCurrentUserId();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> sendEmailVerification();

  Future<bool> checkEmailVerification();

  Future<void> deleteAccount(String? password);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
