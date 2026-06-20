import '../repositories/admin_shop_repository.dart';

class DeleteShop {
  final IAdminShopRepository _repository;

  DeleteShop(this._repository);

  Future<void> call(String shopId) async {
    return await _repository.deleteShop(shopId);
  }
}
