import 'package:street_cart/features/admin/profile/data/models/admin_profile_model.dart';

abstract class IAdminProfileRepository {
  Future<AdminProfileModel> getProfileData();
  Future<void> updateProfileName(String fullName);
}
