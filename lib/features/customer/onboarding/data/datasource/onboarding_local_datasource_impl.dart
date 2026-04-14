import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/features/customer/onboarding/data/datasource/onboarding_local_datasource.dart';

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  @override
  Future<void> setFirstTimeFalse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeAppOpen', false);
  }
}
