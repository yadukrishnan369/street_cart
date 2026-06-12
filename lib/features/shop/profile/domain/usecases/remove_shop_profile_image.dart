import 'package:street_cart/features/shop/profile/domain/repositories/i_shop_profile_repository.dart';

class RemoveShopProfileImage {
  final IShopProfileRepository repository;

  RemoveShopProfileImage(this.repository);

  Future<void> call() async {
    await repository.removeProfileImage();
  }
}
