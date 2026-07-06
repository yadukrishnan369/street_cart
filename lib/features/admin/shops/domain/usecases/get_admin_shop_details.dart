import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/admin/shops/domain/repositories/admin_shop_repository.dart';

class GetAdminShopDetails {
  final IAdminShopRepository _repository;

  GetAdminShopDetails(this._repository);

  Future<ShopProfileModel> call(String shopId) async {
    return await _repository.getShopById(shopId);
  }
}
