import 'package:street_cart/features/admin/auth/domain/repositories/i_admin_auth_repository.dart';
import 'package:street_cart/features/admin/splash/domain/repositories/i_admin_splash_repository.dart';

class AdminSplashRepositoryImpl implements IAdminSplashRepository {
  final IAdminAuthRepository _authRepository;

  AdminSplashRepositoryImpl(this._authRepository);

  @override
  Future<bool> checkAdminSession() async {
    return await _authRepository.checkSession();
  }
}
