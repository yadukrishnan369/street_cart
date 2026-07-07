import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/customer/cart/domain/repositories/i_cart_repository.dart';

class GetShopById {
  final ICartRepository repository;

  GetShopById({required this.repository});

  Future<ShopProfileModel> call(String shopId) async {
    return await repository.getShopById(shopId);
  }
}
