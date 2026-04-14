import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';

class DeleteAddress {
  final IProfileRepository repository;

  DeleteAddress(this.repository);

  Future<void> call(String id) async {
    await repository.deleteAddress(id);
  }
}
