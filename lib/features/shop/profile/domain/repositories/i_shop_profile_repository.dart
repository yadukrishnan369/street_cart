import 'dart:io';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

abstract class IShopProfileRepository {
  Future<ShopProfileModel?> getProfileData();
  Future<void> updateProfileData(ShopProfileModel profile);
  Future<String> uploadProfileImage(File imageFile);
  Future<void> removeProfileImage();
}
