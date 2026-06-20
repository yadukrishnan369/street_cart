import 'package:street_cart/features/admin/profile/data/models/admin_profile_model.dart';
import 'package:street_cart/features/admin/profile/domain/repositories/i_admin_profile_repository.dart';

class GetAdminProfileData {
  final IAdminProfileRepository repository;

  GetAdminProfileData(this.repository);

  Future<AdminProfileModel> call() async {
    return await repository.getProfileData();
  }
}
