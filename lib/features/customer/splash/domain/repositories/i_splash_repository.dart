// App Status Enums
enum AppStatus { firstTime, notLoggedIn, loggedIn }

abstract class ISplashRepository {
  Future<AppStatus> checkAppStatus();
}
