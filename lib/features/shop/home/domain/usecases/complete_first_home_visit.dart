import 'package:street_cart/features/shop/home/domain/repositories/i_shop_home_repository.dart';

class CompleteFirstHomeVisit {
  final IShopHomeRepository repository;

  CompleteFirstHomeVisit(this.repository);

  Future<void> call() async {
    await repository.setFirstHomeVisitFalse();
  }
}
