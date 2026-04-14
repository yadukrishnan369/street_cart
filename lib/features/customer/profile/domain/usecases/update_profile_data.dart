import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';

class UpdateProfileData {
  final IProfileRepository repository;

  UpdateProfileData(this.repository);

  Future<void> call(ProfileModel updatedProfile) async {
    return await repository.updateProfileData(updatedProfile);
  }
}
