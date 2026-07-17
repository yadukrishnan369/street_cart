import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';
import 'package:street_cart/features/customer/auth/data/datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;
  final INetworkInfo _networkInfo;

  AuthRepositoryImpl({
    required IAuthRemoteDataSource remoteDataSource,
    required INetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<void> initiateSignUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }

    await _remoteDataSource.initiateSignUp(email: email, password: password);
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
    required String fullName,
    required String email,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
    final uid = await _remoteDataSource.getCurrentUserId();
    if (uid != null) {
      await _remoteDataSource.finalizeSignUp(
        fullName: fullName,
        email: email,
        userId: uid,
      );
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
  Future<bool> signInWithGoogle() async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }

    return await _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }

    await _remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<ProfileModel?> getCustomer(String userId) async {
    return await _remoteDataSource.getCustomer(userId);
  }

  @override
  Future<void> updateCustomerProfile({
    required String userId,
    required ProfileModel data,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }

    await _remoteDataSource.updateCustomerProfile(userId: userId, data: data);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }

    await _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<bool> isEmailPasswordUser() async {
    return await _remoteDataSource.isEmailPasswordUser();
  }

  @override
  Future<void> deleteAccount(String? password) async {
    if (!await _networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }

    await _remoteDataSource.deleteAccount(password);
  }
}
