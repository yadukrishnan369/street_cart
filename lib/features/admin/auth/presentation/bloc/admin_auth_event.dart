abstract class AdminAuthEvent {
  const AdminAuthEvent();
}

// Login Requested Event
class AdminLoginRequested extends AdminAuthEvent {
  final String email;
  final String password;

  const AdminLoginRequested({required this.email, required this.password});
}

// Check Admin Session Requested Event
class CheckAdminSessionRequested extends AdminAuthEvent {}

// Logout Requested
class AdminLogoutRequested extends AdminAuthEvent {}

// Password Reset Requested Event
class AdminPasswordResetRequested extends AdminAuthEvent {
  final String email;
  const AdminPasswordResetRequested(this.email);
}

// Confirm Password Reset Requested Event
class AdminConfirmPasswordResetRequested extends AdminAuthEvent {
  final String code;
  final String newPassword;
  const AdminConfirmPasswordResetRequested({
    required this.code,
    required this.newPassword,
  });
}

// Session Verified Event
class AdminAuthSessionVerified extends AdminAuthEvent {
  final bool isAuthenticated;
  const AdminAuthSessionVerified(this.isAuthenticated);
}

// Toggle Obscure Password Event
class ToggleObscurePasswordEvent extends AdminAuthEvent {}

// Start Forgot Password Countdown Event
class StartForgotPasswordCountdownEvent extends AdminAuthEvent {}

// Decrement Forgot Password Countdown Event
class DecrementForgotPasswordCountdownEvent extends AdminAuthEvent {}

// Reset Forgot Password Timer Event
class ResetForgotPasswordTimerEvent extends AdminAuthEvent {}
