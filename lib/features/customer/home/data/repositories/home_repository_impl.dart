import 'package:street_cart/features/customer/home/data/datasources/home_remote_datasource.dart';
import 'package:street_cart/features/customer/home/domain/repositories/i_home_repository.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final IHomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HomeData> getHomeData() async {
    try {
      return await remoteDataSource.getHomeData();
    } catch (e) {
      rethrow;
    }
  }
}
