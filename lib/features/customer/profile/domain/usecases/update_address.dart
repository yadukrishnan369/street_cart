import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';

class UpdateAddress {
  final IProfileRepository repository;

  UpdateAddress(this.repository);

  Future<void> call(String id, AddressModel address) async {
    await repository.updateAddress(id, address);
  }
}
