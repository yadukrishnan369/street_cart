import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';

class GetCustomerData {
  final IAuthRepository repository;

  GetCustomerData(this.repository);

  Future<ProfileModel?> call(String userId) async {
    return await repository.getCustomer(userId);
  }
}
