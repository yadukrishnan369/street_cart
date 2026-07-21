abstract class AdminAuthState {
  final bool obscurePassword;
  final int countdown;
  final bool isResetLinkSent;

  const AdminAuthState({
    this.obscurePassword = true,
    this.countdown = 80,
    this.isResetLinkSent = false,
  });
}

// Auth Initial State
class AdminAuthInitial extends AdminAuthState {
  const AdminAuthInitial({
    super.obscurePassword,
    super.countdown,
    super.isResetLinkSent,
  });
}

// Auth Loading State
class AdminAuthLoading extends AdminAuthState {
  const AdminAuthLoading({
    super.obscurePassword,
    super.countdown,
    super.isResetLinkSent,
  });
}

// Auth Success State
class AdminAuthSuccess extends AdminAuthState {
  const AdminAuthSuccess({
    super.obscurePassword,
    super.countdown,
    super.isResetLinkSent,
  });
}

// Auth Failure State
class AdminAuthFailure extends AdminAuthState {
  final String message;

  const AdminAuthFailure(
    this.message, {
    super.obscurePassword,
    super.countdown,
    super.isResetLinkSent,
  });
}

// Unauthenticated State
class AdminUnauthenticated extends AdminAuthState {
  const AdminUnauthenticated({
    super.obscurePassword,
    super.countdown,
    super.isResetLinkSent,
  });
}

// Password Reset Sent State
class AdminAuthPasswordResetSent extends AdminAuthState {
  const AdminAuthPasswordResetSent({
    super.obscurePassword,
    super.countdown,
    super.isResetLinkSent,
  });
}

// Password Reset Success State
class AdminAuthPasswordResetSuccess extends AdminAuthState {
  const AdminAuthPasswordResetSuccess({
    super.obscurePassword,
    super.countdown,
    super.isResetLinkSent,
  });
}

// Password Reset Expired State
class AdminAuthPasswordResetExpired extends AdminAuthState {
  const AdminAuthPasswordResetExpired({
    super.obscurePassword,
    super.countdown,
    super.isResetLinkSent,
  });
}
