import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/sign_in_with_google.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/sign_up.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/login.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/logout.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/send_password_reset_email.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/get_customer_profile.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/update_customer_profile.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/change_password.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/delete_account.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/send_email_verification.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/check_email_verification.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/finalize_sign_up.dart';
import 'package:street_cart/core/error/exceptions.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_bloc.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_event.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUp _signUp;
  final Login _login;
  final SignInWithGoogle _signInWithGoogle;
  final Logout _logout;
  final SendPasswordResetEmail _sendPasswordResetEmail;
  final GetCustomerProfile _getCustomerProfile;
  final UpdateCustomerProfile _updateCustomerProfile;
  final ChangePassword _changePassword;
  final DeleteAccount _deleteAccount;
  final SendEmailVerification _sendEmailVerification;
  final CheckEmailVerification _checkEmailVerification;
  final FinalizeSignUp _finalizeSignUp;

  AuthBloc({
    required SignUp signUp,
    required Login login,
    required SignInWithGoogle signInWithGoogle,
    required Logout logout,
    required SendPasswordResetEmail sendPasswordResetEmail,
    required GetCustomerProfile getCustomerProfile,
    required UpdateCustomerProfile updateCustomerProfile,
    required ChangePassword changePassword,
    required DeleteAccount deleteAccount,
    required SendEmailVerification sendEmailVerification,
    required CheckEmailVerification checkEmailVerification,
    required FinalizeSignUp finalizeSignUp,
  }) : _signUp = signUp,
       _login = login,
       _signInWithGoogle = signInWithGoogle,
       _logout = logout,
       _sendPasswordResetEmail = sendPasswordResetEmail,
       _getCustomerProfile = getCustomerProfile,
       _updateCustomerProfile = updateCustomerProfile,
       _changePassword = changePassword,
       _deleteAccount = deleteAccount,
       _sendEmailVerification = sendEmailVerification,
       _checkEmailVerification = checkEmailVerification,
       _finalizeSignUp = finalizeSignUp,
       super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<SendEmailVerificationEvent>(_onSendEmailVerificationEvent);
    on<CheckEmailVerificationStatusEvent>(_onCheckEmailVerificationStatusEvent);
    on<VerificationCancelledEvent>(_onVerificationCancelledEvent);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _signUp(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );

      // Trigger verification email immediately
      add(SendEmailVerificationEvent());
      
      emit(AuthVerificationWaiting(
        fullName: event.fullName,
        email: event.email,
      ));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onSendEmailVerificationEvent(
    SendEmailVerificationEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _sendEmailVerification();
      if (state is AuthVerificationWaiting) {
        final currentState = state as AuthVerificationWaiting;
        emit(AuthVerificationWaiting(
          fullName: currentState.fullName,
          email: currentState.email,
          isResend: true,
        ));
      }
    } catch (e) {
       // Silent error for resend
    }
  }

  Future<void> _onCheckEmailVerificationStatusEvent(
    CheckEmailVerificationStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isVerified = await _checkEmailVerification();
      if (isVerified) {
        // Only now we finalize signed up by creating Firestore record
        await _finalizeSignUp(
          fullName: event.fullName,
          email: event.email,
        );
        emit(AuthVerificationSuccess());
        emit(AuthSuccess(isNewUser: true, isProfileCompleted: false));
      } else {
        // Silent for polling
      }
    } on ServerException catch (e) {
      // Keep real server errors
      emit(AuthError(e.message));
      emit(AuthVerificationWaiting(
        fullName: event.fullName,
        email: event.email,
      ));
    } catch (e) {
      emit(AuthError('An error occurred: $e'));
      emit(AuthVerificationWaiting(
        fullName: event.fullName,
        email: event.email,
      ));
    }
  }

  Future<void> _onVerificationCancelledEvent(
    VerificationCancelledEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      // Delete the Auth account if user cancels verification
      await _deleteAccount(null);
      emit(AuthInitial());
    } catch (e) {
      emit(AuthInitial());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _login(email: event.email, password: event.password);

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(AuthError("User not found"));
        return;
      }

      final isCompleted = await _getCustomerProfile(user.uid);

      sl<HomeBloc>().add(ResetHome());
      emit(AuthSuccess(isNewUser: false, isProfileCompleted: isCompleted));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final isNewUser = await _signInWithGoogle();

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(AuthError("User not found"));
        return;
      }

      final isCompleted = await _getCustomerProfile(user.uid);

      sl<HomeBloc>().add(ResetHome());
      emit(AuthSuccess(isNewUser: isNewUser, isProfileCompleted: isCompleted));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _logout();
      sl<HomeBloc>().add(ResetHome());
      emit(AuthInitial());
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _sendPasswordResetEmail(email: event.email);
      emit(AuthPasswordResetSuccess());
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(AuthError("User not found"));
        return;
      }
      
      await _updateCustomerProfile(userId: user.uid, data: event.data);
      emit(AuthSuccess(isNewUser: false, isProfileCompleted: true));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _changePassword(
        currentPassword: event.oldPassword,
        newPassword: event.newPassword,
      );
      emit(AuthPasswordChangeSuccess());
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _deleteAccount(event.password);
      sl<HomeBloc>().add(ResetHome());
      emit(AuthAccountDeleted());
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } on NetworkException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError("An unexpected error occurred: $e"));
    }
  }
}
