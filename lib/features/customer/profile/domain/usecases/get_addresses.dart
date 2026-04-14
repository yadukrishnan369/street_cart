import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';

class GetAddresses {
  final IProfileRepository repository;

  GetAddresses(this.repository);

  Future<List<AddressModel>> call() async {
    return await repository.getAddresses();
  }
}
