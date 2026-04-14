import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';

class UpdateCustomerProfile {
  final IAuthRepository repository;

  UpdateCustomerProfile(this.repository);

  Future<void> call({
    required String userId,
    required ProfileModel data,
  }) async {
    return await repository.updateCustomerProfile(userId: userId, data: data);
  }
}
