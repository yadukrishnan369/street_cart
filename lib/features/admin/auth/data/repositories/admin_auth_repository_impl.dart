import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/admin/auth/data/datasource/admin_auth_remote_datasource.dart';
import 'package:street_cart/features/admin/auth/domain/repositories/i_admin_auth_repository.dart';

class AdminAuthRepositoryImpl implements IAdminAuthRepository {
  final IAdminAuthRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  AdminAuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<void> _checkConnection() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException(
        'No internet connection. Please check your network and try again.',
      );
    }
  }

  @override
  Future<bool> login({required String email, required String password}) async {
    await _checkConnection();
    final uid = await remoteDataSource.login(email: email, password: password);
    if (uid != null) {
      final isSuper = await remoteDataSource.isSuperAdmin(uid);
      if (isSuper) {
        return true;
      }

      await remoteDataSource.logout();
      throw Exception(
        'Access denied. You do not have super admin permissions.',
      );
    }
    return false;
  }

  @override
  Future<bool> checkSession() async {
    final uid = await remoteDataSource.getCurrentUserId();
    if (uid != null) {
      final isSuper = await remoteDataSource.isSuperAdmin(uid);
      if (isSuper) {
        return true;
      }
      await remoteDataSource.logout();
    }
    return false;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _checkConnection();
    await remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    await _checkConnection();
    await remoteDataSource.confirmPasswordReset(
      code: code,
      newPassword: newPassword,
    );
  }
}
