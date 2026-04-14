import 'dart:io';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';
import 'package:street_cart/features/customer/profile/data/datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileModel?> getProfileData() {
    return remoteDataSource.getProfileData();
  }

  @override
  Future<void> updateProfileData(ProfileModel updatedProfile) {
    return remoteDataSource.updateProfileData(updatedProfile);
  }

  @override
  Future<String?> uploadProfileImage(File imageFile) {
    return remoteDataSource.uploadImage(imageFile);
  }

  @override
  Future<void> removeProfileImage() {
    return remoteDataSource.removeProfileImage();
  }

  // Address Methods
  @override
  Future<List<AddressModel>> getAddresses() {
    return remoteDataSource.getAddresses();
  }

  @override
  Future<void> addAddress(AddressModel address) {
    return remoteDataSource.addAddress(address);
  }

  @override
  Future<void> updateAddress(String id, AddressModel address) {
    return remoteDataSource.updateAddress(id, address);
  }

  @override
  Future<void> deleteAddress(String id) {
    return remoteDataSource.deleteAddress(id);
  }

  @override
  Future<void> setDefaultAddress(String id) {
    return remoteDataSource.setDefaultAddress(id);
  }
}
