import 'package:street_cart/features/customer/home/domain/repositories/i_home_repository.dart';

abstract class IHomeRemoteDataSource {
  Future<HomeData> getHomeData();
}

