import '../repositories/i_splash_repository.dart';

class CheckAppStatus {
  final ISplashRepository repository;

  CheckAppStatus(this.repository);

  Future<AppStatus> call() async {
    return await repository.checkAppStatus();
  }
}