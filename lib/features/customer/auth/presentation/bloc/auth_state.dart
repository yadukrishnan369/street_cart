abstract class AuthState {}

// INITIAL
class AuthInitial extends AuthState {}

// LOADING
class AuthLoading extends AuthState {}

// SUCCESS
class AuthSuccess extends AuthState {
  final bool isNewUser;
  final bool isProfileCompleted;

  AuthSuccess({required this.isNewUser, required this.isProfileCompleted});
}

class AuthPasswordResetEmailSent extends AuthState {}

class AuthVerificationWaiting extends AuthState {
  final String fullName;
  final String email;
  final bool isResend;
  AuthVerificationWaiting({
    required this.fullName,
    required this.email,
    this.isResend = false,
  });
}

class AuthVerificationSuccess extends AuthState {}

class AuthPasswordResetSuccess extends AuthState {}

class AuthPasswordChangeSuccess extends AuthState {}

// ERROR
class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthAccountDeleted extends AuthState {}
