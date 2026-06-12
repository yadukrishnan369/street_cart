import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/domain/repositories/i_shop_profile_repository.dart';

class GetShopProfileData {
  final IShopProfileRepository repository;

  GetShopProfileData(this.repository);

  Future<ShopProfileModel?> call() async {
    return await repository.getProfileData();
  }
}
