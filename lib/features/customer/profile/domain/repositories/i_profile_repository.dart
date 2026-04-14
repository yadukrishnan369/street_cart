import 'dart:io';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

abstract class IProfileRepository {
  Future<ProfileModel?> getProfileData();
  Future<void> updateProfileData(ProfileModel updatedProfile);
  Future<String?> uploadProfileImage(File imageFile);
  Future<void> removeProfileImage();

  // Address Methods
  Future<List<AddressModel>> getAddresses();
  Future<void> addAddress(AddressModel address);
  Future<void> updateAddress(String id, AddressModel address);
  Future<void> deleteAddress(String id);
  Future<void> setDefaultAddress(String id);
}

