import 'package:street_cart/features/admin/profile/domain/repositories/i_admin_profile_repository.dart';

class UpdateAdminProfileName {
  final IAdminProfileRepository repository;

  UpdateAdminProfileName({required this.repository});

  Future<void> call(String fullName) async {
    return await repository.updateProfileName(fullName);
  }
}
