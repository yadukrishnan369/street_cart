import 'dart:io';
import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class SetupShopProfile {
  final IShopAuthRepository repository;

  SetupShopProfile(this.repository);

  Future<void> call({
    required String category,
    required String description,
    required String gstNumber,
    required File businessLicenseFile,
    required File ownerIdFile,
  }) async {
    return await repository.setupShopProfile(
      category: category,
      description: description,
      gstNumber: gstNumber,
      businessLicenseFile: businessLicenseFile,
      ownerIdFile: ownerIdFile,
    );
  }
}
