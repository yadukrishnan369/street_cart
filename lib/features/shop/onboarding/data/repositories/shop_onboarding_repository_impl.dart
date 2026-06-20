import 'package:street_cart/features/shop/onboarding/data/datasource/shop_onboarding_local_datasource.dart';
import 'package:street_cart/features/shop/onboarding/domain/repositories/i_shop_onboarding_repository.dart';

class ShopOnboardingRepositoryImpl implements IShopOnboardingRepository {
  final IShopOnboardingLocalDataSource local;

  ShopOnboardingRepositoryImpl({required this.local});

  @override
  Future<void> completeOnboarding() async {
    await local.setFirstTimeFalse();
  }
}
