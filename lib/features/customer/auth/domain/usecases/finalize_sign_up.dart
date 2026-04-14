import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class FinalizeSignUp {
  final IAuthRepository repository;

  FinalizeSignUp(this.repository);

  Future<void> call({
    required String fullName,
    required String email,
  }) async {
    await repository.finalizeSignUp(
      fullName: fullName,
      email: email,
    );
  }
}
