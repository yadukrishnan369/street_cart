abstract class IAdminAuthRepository {
  Future<bool> login({required String email, required String password});
  Future<bool> checkSession();
  Future<void> logout();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  });
}
