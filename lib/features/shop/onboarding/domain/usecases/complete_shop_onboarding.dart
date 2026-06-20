import 'package:street_cart/features/shop/onboarding/domain/repositories/i_shop_onboarding_repository.dart';

class CompleteShopOnboarding {
  final IShopOnboardingRepository repository;

  CompleteShopOnboarding(this.repository);

  Future<void> call() async {
    await repository.completeOnboarding();
  }
}
