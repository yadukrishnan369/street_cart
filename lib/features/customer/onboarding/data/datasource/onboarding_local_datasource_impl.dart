import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/features/customer/onboarding/data/datasource/onboarding_local_datasource.dart';

// Saves onboarding completion status
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  @override
  // sets first time app open setting to false
  Future<void> setFirstTimeFalse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTimeAppOpen', false);
  }
}
