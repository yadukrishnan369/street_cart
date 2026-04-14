import 'dart:io';
import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';

class UploadProfileImage {
  final IProfileRepository repository;

  UploadProfileImage(this.repository);

  Future<String?> call(File imageFile) async {
    return await repository.uploadProfileImage(imageFile);
  }
}
