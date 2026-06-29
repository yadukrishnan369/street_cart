import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class GetProductCategories {
  final IShopAuthRepository _repository;

  GetProductCategories(this._repository);

  Future<List<String>> call() async {
    return await _repository.getProductCategories();
  }
}
