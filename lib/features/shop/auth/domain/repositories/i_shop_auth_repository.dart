import 'dart:io';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class IShopAuthRepository {
  Future<void> signUp({
    required String email,
    required String password,
    required String ownerName,
    required String shopName,
  });

  Future<void> initiateSignUp({
    required String email,
    required String password,
  });

  Future<void> sendEmailVerification();

  Future<bool> checkEmailVerification();

  Future<void> finalizeSignUp({
    required String ownerName,
    required String shopName,
    required String email,
  });

  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> setupShopProfile({
    required String category,
    required String description,
    required String gstNumber,
    required File businessLicenseFile,
    required File ownerIdFile,
  });

  Stream<ShopProfileModel?> getShopStatus();

  Future<void> logout();

  Future<String?> getCurrentUserId();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> deleteAccount(String? password);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<List<String>> getBusinessCategories();

  Future<List<String>> getProductCategories();

  Future<Map<String, bool>> getPaymentSettings();
}
