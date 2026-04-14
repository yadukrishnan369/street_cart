import 'package:shared_preferences/shared_preferences.dart';
import 'splash_local_datasource.dart';

class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  @override
  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstTimeAppOpen') ?? true;
  }
}