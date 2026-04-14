import 'package:street_cart/features/customer/home/data/datasources/home_remote_datasource.dart';
import 'package:street_cart/features/customer/home/domain/repositories/i_home_repository.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final IHomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String?> getHomeAddress() async {
    try {
      return await remoteDataSource.getCustomerAddress();
    } catch (e) {
      // In a real app, you might map this to a specific Failure type
      rethrow;
    }
  }
}
