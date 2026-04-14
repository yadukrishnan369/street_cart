import 'package:street_cart/features/customer/onboarding/data/datasource/onboarding_local_datasource.dart';
import 'package:street_cart/features/customer/onboarding/domain/repositories/i_onboarding_repository.dart';

class OnboardingRepositoryImpl implements IOnboardingRepository {
  final OnboardingLocalDataSource local;

  OnboardingRepositoryImpl({required this.local});

  @override
  Future<void> completeOnboarding() async {
    await local.setFirstTimeFalse();
  }
}
