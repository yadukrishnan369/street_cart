import 'dart:io';
import 'package:street_cart/features/shop/profile/domain/repositories/i_shop_profile_repository.dart';

class UploadShopProfileImage {
  final IShopProfileRepository repository;

  UploadShopProfileImage(this.repository);

  Future<String> call(File imageFile) async {
    return await repository.uploadProfileImage(imageFile);
  }
}
