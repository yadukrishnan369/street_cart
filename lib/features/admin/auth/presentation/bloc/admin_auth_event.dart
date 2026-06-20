abstract class AdminAuthEvent {
  const AdminAuthEvent();
}

class AdminLoginRequested extends AdminAuthEvent {
  final String email;
  final String password;

  const AdminLoginRequested({required this.email, required this.password});
}

class CheckAdminSessionRequested extends AdminAuthEvent {}

class AdminLogoutRequested extends AdminAuthEvent {}

class AdminPasswordResetRequested extends AdminAuthEvent {
  final String email;
  const AdminPasswordResetRequested(this.email);
}

class AdminConfirmPasswordResetRequested extends AdminAuthEvent {
  final String code;
  final String newPassword;
  const AdminConfirmPasswordResetRequested({
    required this.code,
    required this.newPassword,
  });
}

class AdminAuthSessionVerified extends AdminAuthEvent {
  final bool isAuthenticated;
  const AdminAuthSessionVerified(this.isAuthenticated);
}
