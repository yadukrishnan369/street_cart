import 'package:street_cart/features/admin/auth/data/datasource/admin_auth_remote_datasource.dart';
import 'package:street_cart/features/admin/auth/domain/repositories/i_admin_auth_repository.dart';

class AdminAuthRepositoryImpl implements IAdminAuthRepository {
  final IAdminAuthRemoteDataSource remoteDataSource;

  AdminAuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> login({required String email, required String password}) async {
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
    await remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    await remoteDataSource.confirmPasswordReset(
      code: code,
      newPassword: newPassword,
    );
  }
}
