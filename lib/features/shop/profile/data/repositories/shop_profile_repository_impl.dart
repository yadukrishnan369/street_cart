import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/data/datasources/shop_profile_remote_datasource.dart';
import 'package:street_cart/features/shop/profile/domain/repositories/i_shop_profile_repository.dart';

class ShopProfileRepositoryImpl implements IShopProfileRepository {
  final IShopProfileRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;
  final FirebaseAuth _auth;

  ShopProfileRepositoryImpl({
    required IShopProfileRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
    required FirebaseAuth auth,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo,
       _auth = auth;

  @override
  Future<ShopProfileModel?> getProfileData() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw ServerException('No authenticated user session found.');
    }
    return await _remoteDataSource.getShopProfile(uid);
  }

  @override
  Future<void> updateProfileData(ShopProfileModel profile) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw ServerException('No authenticated user session found.');
    }
    await _remoteDataSource.updateShopProfile(userId: uid, data: profile);
  }

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return await _remoteDataSource.uploadProfileImage(imageFile);
  }

  @override
  Future<void> removeProfileImage() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw ServerException('No authenticated user session found.');
    }
    await _remoteDataSource.removeProfileImage(uid);
  }
}
