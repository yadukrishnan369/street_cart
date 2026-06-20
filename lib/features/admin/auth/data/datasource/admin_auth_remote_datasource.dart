abstract class IAdminAuthRemoteDataSource {
  Future<String?> login({required String email, required String password});
  Future<String?> getCurrentUserId();
  Future<String?> getCurrentUserEmail();
  Future<bool> isSuperAdmin(String uid);
  Future<void> logout();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  });
}
