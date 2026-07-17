import 'dart:async';
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

  // local UI states
  bool _isPasswordVisible = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;
  bool _isVerificationSheetShowing = false;
  int _secondsRemaining = 90;
  Timer? _pollingTimer;
  Timer? _countdownTimer;

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    return super.close();
  }

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
       super(const AuthInitial()) {
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
    on<ToggleLoginPasswordVisibility>((event, emit) {
      _isPasswordVisible = !_isPasswordVisible;
      _emit(emit, state);
    });
    on<ToggleSignupPasswordVisibility>((event, emit) {
      _obscurePassword = !_obscurePassword;
      _emit(emit, state);
    });
    on<ToggleConfirmPasswordVisibility>((event, emit) {
      _obscureConfirmPassword = !_obscureConfirmPassword;
      _emit(emit, state);
    });
    on<ToggleTermsAgreement>((event, emit) {
      _agreedToTerms = event.agreed;
      _emit(emit, state);
    });
    on<SetVerificationSheetShowing>((event, emit) {
      _isVerificationSheetShowing = event.showing;
      _emit(emit, state);
    });
    on<StartVerificationTimerEvent>((event, emit) {
      _pollingTimer?.cancel();
      _countdownTimer?.cancel();
      _secondsRemaining = 90;

      _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        add(
          CheckEmailVerificationStatusEvent(
            fullName: event.fullName,
            email: event.email,
          ),
        );
      });

      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        add(DecrementVerificationTimer());
      });

      _emit(
        emit,
        AuthVerificationWaiting(fullName: event.fullName, email: event.email),
      );
    });
    on<DecrementVerificationTimer>((event, emit) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        _emit(emit, state);
      } else {
        _pollingTimer?.cancel();
        _countdownTimer?.cancel();
        _emit(
          emit,
          const AuthError('Verification time expired. Please try again.'),
        );
      }
    });
    on<ResetVerificationTimer>((event, emit) {
      _secondsRemaining = 90;
      _emit(emit, state);
    });
  }

  // emit helper
  void _emit(Emitter<AuthState> emit, AuthState newState) {
    if (newState is AuthInitial) {
      emit(
        AuthInitial(
          isPasswordVisible: _isPasswordVisible,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          agreedToTerms: _agreedToTerms,
          isVerificationSheetShowing: _isVerificationSheetShowing,
          secondsRemaining: _secondsRemaining,
        ),
      );
    } else if (newState is AuthLoading) {
      emit(
        AuthLoading(
          isPasswordVisible: _isPasswordVisible,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          agreedToTerms: _agreedToTerms,
          isVerificationSheetShowing: _isVerificationSheetShowing,
          secondsRemaining: _secondsRemaining,
        ),
      );
    } else if (newState is AuthSuccess) {
      emit(
        AuthSuccess(
          isNewUser: newState.isNewUser,
          isProfileCompleted: newState.isProfileCompleted,
          isPasswordVisible: _isPasswordVisible,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          agreedToTerms: _agreedToTerms,
          isVerificationSheetShowing: _isVerificationSheetShowing,
          secondsRemaining: _secondsRemaining,
        ),
      );
    } else if (newState is AuthVerificationWaiting) {
      emit(
        AuthVerificationWaiting(
          fullName: newState.fullName,
          email: newState.email,
          isResend: newState.isResend,
          isPasswordVisible: _isPasswordVisible,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          agreedToTerms: _agreedToTerms,
          isVerificationSheetShowing: _isVerificationSheetShowing,
          secondsRemaining: _secondsRemaining,
        ),
      );
    } else if (newState is AuthVerificationSuccess) {
      emit(
        AuthVerificationSuccess(
          isPasswordVisible: _isPasswordVisible,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          agreedToTerms: _agreedToTerms,
          isVerificationSheetShowing: _isVerificationSheetShowing,
          secondsRemaining: _secondsRemaining,
        ),
      );
    } else if (newState is AuthPasswordResetEmailSent) {
      emit(
        AuthPasswordResetEmailSent(
          isPasswordVisible: _isPasswordVisible,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          agreedToTerms: _agreedToTerms,
          isVerificationSheetShowing: _isVerificationSheetShowing,
          secondsRemaining: _secondsRemaining,
        ),
      );
    } else if (newState is AuthPasswordResetSuccess) {
      emit(
        AuthPasswordResetSuccess(
          isPasswordVisible: _isPasswordVisible,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          agreedToTerms: _agreedToTerms,
          isVerificationSheetShowing: _isVerificationSheetShowing,
          secondsRemaining: _secondsRemaining,
        ),
      );
    } else if (newState is AuthPasswordChangeSuccess) {
      emit(
        AuthPasswordChangeSuccess(
          isPasswordVisible: _isPasswordVisible,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          agreedToTerms: _agreedToTerms,
          isVerificationSheetShowing: _isVerificationSheetShowing,
          secondsRemaining: _secondsRemaining,
        ),
      );
    } else if (newState is AuthError) {
      emit(
        AuthError(
          newState.message,
          isPasswordVisible: _isPasswordVisible,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          agreedToTerms: _agreedToTerms,
          isVerificationSheetShowing: _isVerificationSheetShowing,
          secondsRemaining: _secondsRemaining,
        ),
      );
    } else if (newState is AuthAccountDeleted) {
      emit(
        AuthAccountDeleted(
          isPasswordVisible: _isPasswordVisible,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          agreedToTerms: _agreedToTerms,
          isVerificationSheetShowing: _isVerificationSheetShowing,
          secondsRemaining: _secondsRemaining,
        ),
      );
    } else {
      emit(newState);
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    _emit(emit, AuthLoading());

    try {
      await _signUp(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );

      // Trigger verification email
      add(SendEmailVerificationEvent());

      _emit(
        emit,
        AuthVerificationWaiting(fullName: event.fullName, email: event.email),
      );
    } on ServerException catch (e) {
      _emit(emit, AuthError(e.message));
    } on NetworkException catch (e) {
      _emit(emit, AuthError(e.message));
    } catch (e) {
      _emit(emit, AuthError("An unexpected error occurred: $e"));
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
        _emit(
          emit,
          AuthVerificationWaiting(
            fullName: currentState.fullName,
            email: currentState.email,
            isResend: true,
          ),
        );
      }
    } catch (e) {
      // error for resend
    }
  }

  Future<void> _onCheckEmailVerificationStatusEvent(
    CheckEmailVerificationStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isVerified = await _checkEmailVerification();
      if (isVerified) {
        _pollingTimer?.cancel();
        _countdownTimer?.cancel();
        // finalize signed up by creating record
        await _finalizeSignUp(fullName: event.fullName, email: event.email);
        _emit(emit, AuthVerificationSuccess());
        _emit(emit, AuthSuccess(isNewUser: true, isProfileCompleted: false));
      } else {
        // break polling
      }
    } on ServerException catch (e) {
      _emit(emit, AuthError(e.message));
      _emit(
        emit,
        AuthVerificationWaiting(fullName: event.fullName, email: event.email),
      );
    } catch (e) {
      _emit(emit, AuthError('An error occurred: $e'));
      _emit(
        emit,
        AuthVerificationWaiting(fullName: event.fullName, email: event.email),
      );
    }
  }

  Future<void> _onVerificationCancelledEvent(
    VerificationCancelledEvent event,
    Emitter<AuthState> emit,
  ) async {
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    try {
      // Delete the account if user cancels verification
      await _deleteAccount(null);
      _emit(emit, AuthInitial());
    } catch (e) {
      _emit(emit, AuthInitial());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    _emit(emit, AuthLoading());

    try {
      await _login(email: event.email, password: event.password);

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _emit(emit, AuthError("User not found"));
        return;
      }

      final isCompleted = await _getCustomerProfile(user.uid);

      sl<HomeBloc>().add(ResetHome());
      _emit(
        emit,
        AuthSuccess(isNewUser: false, isProfileCompleted: isCompleted),
      );
    } on ServerException catch (e) {
      _emit(emit, AuthError(e.message));
    } on NetworkException catch (e) {
      _emit(emit, AuthError(e.message));
    } catch (e) {
      _emit(emit, AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    _emit(emit, AuthLoading());

    try {
      final isNewUser = await _signInWithGoogle();

      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        _emit(emit, AuthError("User not found"));
        return;
      }

      final isCompleted = await _getCustomerProfile(user.uid);

      sl<HomeBloc>().add(ResetHome());
      _emit(
        emit,
        AuthSuccess(isNewUser: isNewUser, isProfileCompleted: isCompleted),
      );
    } on ServerException catch (e) {
      _emit(emit, AuthError(e.message));
    } on NetworkException catch (e) {
      _emit(emit, AuthError(e.message));
    } catch (e) {
      _emit(emit, AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _logout();
      sl<HomeBloc>().add(ResetHome());
      _emit(emit, AuthInitial());
    } on ServerException catch (e) {
      _emit(emit, AuthError(e.message));
    } on NetworkException catch (e) {
      _emit(emit, AuthError(e.message));
    } catch (e) {
      _emit(emit, AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    _emit(emit, AuthLoading());

    try {
      await _sendPasswordResetEmail(email: event.email);
      _emit(emit, AuthPasswordResetSuccess());
    } on ServerException catch (e) {
      _emit(emit, AuthError(e.message));
    } on NetworkException catch (e) {
      _emit(emit, AuthError(e.message));
    } catch (e) {
      _emit(emit, AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    _emit(emit, AuthLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _emit(emit, AuthError("User not found"));
        return;
      }

      await _updateCustomerProfile(userId: user.uid, data: event.data);
      _emit(emit, AuthSuccess(isNewUser: false, isProfileCompleted: true));
    } on ServerException catch (e) {
      _emit(emit, AuthError(e.message));
    } on NetworkException catch (e) {
      _emit(emit, AuthError(e.message));
    } catch (e) {
      _emit(emit, AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    _emit(emit, AuthLoading());

    try {
      await _changePassword(
        currentPassword: event.oldPassword,
        newPassword: event.newPassword,
      );
      _emit(emit, AuthPasswordChangeSuccess());
    } on ServerException catch (e) {
      _emit(emit, AuthError(e.message));
    } on NetworkException catch (e) {
      _emit(emit, AuthError(e.message));
    } catch (e) {
      _emit(emit, AuthError("An unexpected error occurred: $e"));
    }
  }

  Future<void> _onDeleteAccountRequested(
    DeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    _emit(emit, AuthLoading());

    try {
      await _deleteAccount(event.password);
      sl<HomeBloc>().add(ResetHome());
      _emit(emit, AuthAccountDeleted());
    } on ServerException catch (e) {
      _emit(emit, AuthError(e.message));
    } on NetworkException catch (e) {
      _emit(emit, AuthError(e.message));
    } catch (e) {
      _emit(emit, AuthError("An unexpected error occurred: $e"));
    }
  }
}
