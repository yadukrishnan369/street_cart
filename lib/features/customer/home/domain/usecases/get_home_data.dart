import 'package:street_cart/features/customer/home/domain/repositories/i_home_repository.dart';

class GetHomeData {
  final IHomeRepository repository;

  GetHomeData(this.repository);

  Future<HomeData> call() {
    return repository.getHomeData();
  }
}
