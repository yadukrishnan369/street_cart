import 'dart:io';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class IShopProfileRemoteDataSource {
  Future<ShopProfileModel?> getShopProfile(String userId);
  Future<void> updateShopProfile({
    required String userId,
    required ShopProfileModel data,
  });
  Future<String> uploadProfileImage(File imageFile);
  Future<void> removeProfileImage(String userId);
}
