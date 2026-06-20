import 'package:street_cart/features/shop/home/domain/repositories/i_shop_home_repository.dart';

class CheckFirstHomeVisit {
  final IShopHomeRepository repository;

  CheckFirstHomeVisit(this.repository);

  Future<bool> call() async {
    return await repository.isFirstHomeVisit();
  }
}
