import 'package:street_cart/features/customer/home/domain/repositories/i_home_repository.dart';

class GetHomeAddress {
  final IHomeRepository repository;

  GetHomeAddress(this.repository);

  Future<String?> call() {
    return repository.getHomeAddress();
  }
}
