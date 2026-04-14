import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';

class GetProfileData {
  final IProfileRepository repository;

  GetProfileData(this.repository);

  Future<ProfileModel?> call() async {
    return await repository.getProfileData();
  }
}
