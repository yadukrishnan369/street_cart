import 'package:street_cart/features/admin/splash/domain/repositories/i_admin_splash_repository.dart';

class CheckAdminSplashSession {
  final IAdminSplashRepository repository;

  CheckAdminSplashSession(this.repository);

  Future<bool> call() async {
    return await repository.checkAdminSession();
  }
}
