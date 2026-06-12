import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/profile/domain/repositories/i_shop_profile_repository.dart';

class UpdateShopProfileData {
  final IShopProfileRepository repository;

  UpdateShopProfileData(this.repository);

  Future<void> call(ShopProfileModel profile) async {
    await repository.updateProfileData(profile);
  }
}
