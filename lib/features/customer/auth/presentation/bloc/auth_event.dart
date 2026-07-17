import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';

abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  SignUpRequested({
    required this.email,
    required this.password,
    required this.fullName,
  });
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

class GoogleSignInRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class PasswordResetRequested extends AuthEvent {
  final String email;

  PasswordResetRequested(this.email);
}

class UpdateProfileRequested extends AuthEvent {
  final ProfileModel data;

  UpdateProfileRequested({required this.data});
}

class ChangePasswordRequested extends AuthEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequested({
    required this.oldPassword,
    required this.newPassword,
  });
}

class DeleteAccountRequested extends AuthEvent {
  final String? password;

  DeleteAccountRequested(this.password);
}

class SendEmailVerificationEvent extends AuthEvent {}

class CheckEmailVerificationStatusEvent extends AuthEvent {
  final String fullName;
  final String email;

  CheckEmailVerificationStatusEvent({
    required this.fullName,
    required this.email,
  });
}

class VerificationCancelledEvent extends AuthEvent {}

// Events for UI
class ToggleLoginPasswordVisibility extends AuthEvent {}

class ToggleSignupPasswordVisibility extends AuthEvent {}

class ToggleConfirmPasswordVisibility extends AuthEvent {}

class ToggleTermsAgreement extends AuthEvent {
  final bool agreed;
  ToggleTermsAgreement(this.agreed);
}

class SetVerificationSheetShowing extends AuthEvent {
  final bool showing;
  SetVerificationSheetShowing(this.showing);
}

class DecrementVerificationTimer extends AuthEvent {}

class ResetVerificationTimer extends AuthEvent {}

class StartVerificationTimerEvent extends AuthEvent {
  final String fullName;
  final String email;
  StartVerificationTimerEvent({required this.fullName, required this.email});
}
