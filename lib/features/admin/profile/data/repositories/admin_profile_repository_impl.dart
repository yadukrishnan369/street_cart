import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/features/admin/profile/data/datasources/admin_profile_remote_datasource.dart';
import 'package:street_cart/features/admin/profile/data/models/admin_profile_model.dart';
import 'package:street_cart/features/admin/profile/domain/repositories/i_admin_profile_repository.dart';

class AdminProfileRepositoryImpl implements IAdminProfileRepository {
  final IAdminProfileRemoteDataSource remoteDataSource;
  final INetworkInfo networkInfo;

  AdminProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<void> _checkConnection() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('Please check your internet connection.');
    }
  }

  @override
  Future<AdminProfileModel> getProfileData() async {
    await _checkConnection();
    return await remoteDataSource.getProfileData();
  }

  @override
  Future<void> updateProfileName(String fullName) async {
    await _checkConnection();
    return await remoteDataSource.updateProfileName(fullName);
  }
}
