import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';

class SetDefaultAddress {
  final IProfileRepository repository;

  SetDefaultAddress(this.repository);

  Future<void> call(String id) async {
    await repository.setDefaultAddress(id);
  }
}
