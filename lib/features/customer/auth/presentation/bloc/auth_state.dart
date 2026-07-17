abstract class AuthState {
  final bool isPasswordVisible;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool agreedToTerms;
  final bool isVerificationSheetShowing;
  final int secondsRemaining;

  const AuthState({
    this.isPasswordVisible = false,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.agreedToTerms = false,
    this.isVerificationSheetShowing = false,
    this.secondsRemaining = 90,
  });
}

// Initial state
class AuthInitial extends AuthState {
  const AuthInitial({
    super.isPasswordVisible,
    super.obscurePassword,
    super.obscureConfirmPassword,
    super.agreedToTerms,
    super.isVerificationSheetShowing,
    super.secondsRemaining,
  });
}

// Loading state
class AuthLoading extends AuthState {
  const AuthLoading({
    super.isPasswordVisible,
    super.obscurePassword,
    super.obscureConfirmPassword,
    super.agreedToTerms,
    super.isVerificationSheetShowing,
    super.secondsRemaining,
  });
}

// Success states
class AuthSuccess extends AuthState {
  final bool isNewUser;
  final bool isProfileCompleted;

  const AuthSuccess({
    required this.isNewUser,
    required this.isProfileCompleted,
    super.isPasswordVisible,
    super.obscurePassword,
    super.obscureConfirmPassword,
    super.agreedToTerms,
    super.isVerificationSheetShowing,
    super.secondsRemaining,
  });
}

class AuthPasswordResetEmailSent extends AuthState {
  const AuthPasswordResetEmailSent({
    super.isPasswordVisible,
    super.obscurePassword,
    super.obscureConfirmPassword,
    super.agreedToTerms,
    super.isVerificationSheetShowing,
    super.secondsRemaining,
  });
}

class AuthVerificationWaiting extends AuthState {
  final String fullName;
  final String email;
  final bool isResend;

  const AuthVerificationWaiting({
    required this.fullName,
    required this.email,
    this.isResend = false,
    super.isPasswordVisible,
    super.obscurePassword,
    super.obscureConfirmPassword,
    super.agreedToTerms,
    super.isVerificationSheetShowing,
    super.secondsRemaining,
  });
}

class AuthVerificationSuccess extends AuthState {
  const AuthVerificationSuccess({
    super.isPasswordVisible,
    super.obscurePassword,
    super.obscureConfirmPassword,
    super.agreedToTerms,
    super.isVerificationSheetShowing,
    super.secondsRemaining,
  });
}

class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess({
    super.isPasswordVisible,
    super.obscurePassword,
    super.obscureConfirmPassword,
    super.agreedToTerms,
    super.isVerificationSheetShowing,
    super.secondsRemaining,
  });
}

class AuthPasswordChangeSuccess extends AuthState {
  const AuthPasswordChangeSuccess({
    super.isPasswordVisible,
    super.obscurePassword,
    super.obscureConfirmPassword,
    super.agreedToTerms,
    super.isVerificationSheetShowing,
    super.secondsRemaining,
  });
}

// Error states
class AuthError extends AuthState {
  final String message;

  const AuthError(
    this.message, {
    super.isPasswordVisible,
    super.obscurePassword,
    super.obscureConfirmPassword,
    super.agreedToTerms,
    super.isVerificationSheetShowing,
    super.secondsRemaining,
  });
}

class AuthAccountDeleted extends AuthState {
  const AuthAccountDeleted({
    super.isPasswordVisible,
    super.obscurePassword,
    super.obscureConfirmPassword,
    super.agreedToTerms,
    super.isVerificationSheetShowing,
    super.secondsRemaining,
  });
}
