import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';

class AddAddress {
  final IProfileRepository repository;

  AddAddress(this.repository);

  Future<void> call(AddressModel address) async {
    await repository.addAddress(address);
  }
}
