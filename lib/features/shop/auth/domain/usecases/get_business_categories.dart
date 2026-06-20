import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';

class GetBusinessCategories {
  final IShopAuthRepository _repository;

  GetBusinessCategories(this._repository);

  Future<List<String>> call() async {
    return await _repository.getBusinessCategories();
  }
}
