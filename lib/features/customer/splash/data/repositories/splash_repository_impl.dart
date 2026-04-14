import 'package:street_cart/features/customer/splash/data/datasources/splash_local_datasource.dart';
import 'package:street_cart/features/customer/splash/data/datasources/splash_remote_datasource.dart';
import 'package:street_cart/features/customer/splash/domain/repositories/i_splash_repository.dart';

class SplashRepositoryImpl implements ISplashRepository {
  final SplashLocalDataSource local;
  final SplashRemoteDataSource remote;

  SplashRepositoryImpl({required this.local, required this.remote});

  @override
  Future<AppStatus> checkAppStatus() async {
    final isFirstTime = await local.isFirstTime();

    if (isFirstTime) return AppStatus.firstTime;

    final user = remote.getCurrentUser();

    if (user == null) return AppStatus.notLoggedIn;

    return AppStatus.loggedIn;
  }
}
