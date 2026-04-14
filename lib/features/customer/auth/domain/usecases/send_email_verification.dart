import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class SendEmailVerification {
  final IAuthRepository repository;

  SendEmailVerification(this.repository);

  Future<void> call() async {
    await repository.sendEmailVerification();
  }
}
