import 'package:street_cart/features/admin/profile/data/datasources/admin_profile_remote_datasource.dart';
import 'package:street_cart/features/admin/profile/data/models/admin_profile_model.dart';
import 'package:street_cart/features/admin/profile/domain/repositories/i_admin_profile_repository.dart';

class AdminProfileRepositoryImpl implements IAdminProfileRepository {
  final IAdminProfileRemoteDataSource remoteDataSource;

  AdminProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AdminProfileModel> getProfileData() async {
    return await remoteDataSource.getProfileData();
  }

  @override
  Future<void> updateProfileName(String fullName) async {
    return await remoteDataSource.updateProfileName(fullName);
  }
}
