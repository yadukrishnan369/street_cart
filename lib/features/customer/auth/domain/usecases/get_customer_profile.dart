import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class GetCustomerProfile {
  final IAuthRepository repository;

  GetCustomerProfile(this.repository);

  Future<bool> call(String userId) async {
    final profile = await repository.getCustomer(userId);
    return profile != null; // Since if it exists, it must have basic fields from sign-up
  }
}
