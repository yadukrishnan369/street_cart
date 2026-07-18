import 'dart:io';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';
import 'package:street_cart/features/customer/profile/data/datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<ProfileModel?> getProfileData() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.getProfileData();
  }

  @override
  Future<void> updateProfileData(ProfileModel updatedProfile) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.updateProfileData(updatedProfile);
  }

  @override
  Future<String?> uploadProfileImage(File imageFile) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.uploadImage(imageFile);
  }

  @override
  Future<void> removeProfileImage() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.removeProfileImage();
  }

  // Address Methods
  @override
  Future<List<AddressModel>> getAddresses() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.getAddresses();
  }

  @override
  Future<void> addAddress(AddressModel address) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.addAddress(address);
  }

  @override
  Future<void> updateAddress(String id, AddressModel address) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.updateAddress(id, address);
  }

  @override
  Future<void> deleteAddress(String id) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.deleteAddress(id);
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return remoteDataSource.setDefaultAddress(id);
  }
}
