import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class SendPasswordResetEmail {
  final IAuthRepository repository;

  SendPasswordResetEmail(this.repository);

  Future<void> call({required String email}) async {
    return await repository.sendPasswordResetEmail(email);
  }
}
