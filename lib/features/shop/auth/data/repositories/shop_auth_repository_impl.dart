import 'dart:io';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/features/shop/auth/data/datasource/shop_auth_remote_datasource.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class ShopAuthRepositoryImpl implements IShopAuthRepository {
  final IShopAuthRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  ShopAuthRepositoryImpl({
    required IShopAuthRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String ownerName,
    required String shopName,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }

    try {
      await _remoteDataSource.signUp(email: email, password: password);
      final uid = await _remoteDataSource.getCurrentUserId();
      if (uid != null) {
        await _remoteDataSource.finalizeSignUp(
          ownerName: ownerName,
          shopName: shopName,
          email: email,
          userId: uid,
        );
      }
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> login({required String email, required String password}) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    await _remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> setupShopProfile({
    required String category,
    required String description,
    required String gstNumber,
    required File businessLicenseFile,
    required File ownerIdFile,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }

    final uid = await _remoteDataSource.getCurrentUserId();
    if (uid == null) throw ServerException('Session expired. Please login again.');

    await _remoteDataSource.setupShopProfile(
      userId: uid,
      category: category,
      description: description,
      gstNumber: gstNumber,
      businessLicenseFile: businessLicenseFile,
      ownerIdFile: ownerIdFile,
    );
  }

  @override
  Stream<ShopProfileModel?> getShopStatus() {
    return _remoteDataSource.getAuthUserIdChanges().asyncExpand((uid) {
      if (uid == null) return Stream.value(null);
      return _remoteDataSource.getShopStatus(uid);
    });
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  @override
  Future<String?> getCurrentUserId() async {
    return _remoteDataSource.getCurrentUserId();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    await _remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> initiateSignUp({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    await _remoteDataSource.signUp(email: email, password: password);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    await _remoteDataSource.sendEmailVerification();
  }

  @override
  Future<bool> checkEmailVerification() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    return await _remoteDataSource.checkEmailVerification();
  }

  @override
  Future<void> finalizeSignUp({
    required String ownerName,
    required String shopName,
    required String email,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    final uid = await _remoteDataSource.getCurrentUserId();
    if (uid != null) {
      await _remoteDataSource.finalizeSignUp(
        ownerName: ownerName,
        shopName: shopName,
        email: email,
        userId: uid,
      );
    }
  }

  @override
  Future<void> deleteAccount(String? password) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    await _remoteDataSource.deleteAccount(password);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getBusinessCategories() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      return await _remoteDataSource.getBusinessCategories();
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, bool>> getPaymentSettings() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    try {
      return await _remoteDataSource.getPaymentSettings();
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
