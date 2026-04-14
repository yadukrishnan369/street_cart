import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';

abstract class IAuthRemoteDataSource {
  Future<void> initiateSignUp({
    required String email,
    required String password,
  });

  Future<void> sendEmailVerification();
  Future<bool> checkEmailVerification();

  Future<void> finalizeSignUp({
    required String fullName,
    required String email,
    required String userId,
  });

  Future<void> login({required String email, required String password});

  Future<bool> signInWithGoogle();

  Future<void> logout();

  Future<void> sendPasswordResetEmail(String email);

  Future<ProfileModel?> getCustomer(String userId);
  Future<void> updateCustomerProfile({
    required String userId,
    required ProfileModel data,
  });

  Future<String?> getCurrentUserId();
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<bool> isEmailPasswordUser();
  Future<void> deleteAccount(String? password);
}
