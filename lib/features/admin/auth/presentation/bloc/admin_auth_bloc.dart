import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/admin_login.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/check_admin_session.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/admin_logout.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/send_admin_password_reset.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/confirm_admin_password_reset.dart';
import 'admin_auth_event.dart';
import 'admin_auth_state.dart';

class AdminAuthBloc extends Bloc<AdminAuthEvent, AdminAuthState> {
  final AdminLogin loginUseCase;
  final CheckAdminSession checkSessionUseCase;
  final AdminLogout logoutUseCase;
  final SendAdminPasswordReset sendPasswordResetUseCase;
  final ConfirmAdminPasswordReset confirmPasswordResetUseCase;

  Timer? _timer;

  AdminAuthBloc({
    required this.loginUseCase,
    required this.checkSessionUseCase,
    required this.logoutUseCase,
    required this.sendPasswordResetUseCase,
    required this.confirmPasswordResetUseCase,
  }) : super(const AdminAuthInitial()) {
    // Admin Login Requested
    on<AdminLoginRequested>((event, emit) async {
      emit(
        AdminAuthLoading(
          obscurePassword: state.obscurePassword,
          countdown: state.countdown,
          isResetLinkSent: state.isResetLinkSent,
        ),
      );
      try {
        final success = await loginUseCase(
          email: event.email,
          password: event.password,
        );
        if (success) {
          emit(
            AdminAuthSuccess(
              obscurePassword: state.obscurePassword,
              countdown: state.countdown,
              isResetLinkSent: state.isResetLinkSent,
            ),
          );
        } else {
          emit(
            AdminAuthFailure(
              'Authentication failed.',
              obscurePassword: state.obscurePassword,
              countdown: state.countdown,
              isResetLinkSent: state.isResetLinkSent,
            ),
          );
        }
      } catch (e) {
        emit(
          AdminAuthFailure(
            _formatError(e),
            obscurePassword: state.obscurePassword,
            countdown: state.countdown,
            isResetLinkSent: state.isResetLinkSent,
          ),
        );
      }
    });

    // Check Admin Session Requested
    on<CheckAdminSessionRequested>((event, emit) async {
      emit(
        AdminAuthLoading(
          obscurePassword: state.obscurePassword,
          countdown: state.countdown,
          isResetLinkSent: state.isResetLinkSent,
        ),
      );
      try {
        final success = await checkSessionUseCase();
        if (success) {
          emit(
            AdminAuthSuccess(
              obscurePassword: state.obscurePassword,
              countdown: state.countdown,
              isResetLinkSent: state.isResetLinkSent,
            ),
          );
        } else {
          emit(
            AdminUnauthenticated(
              obscurePassword: state.obscurePassword,
              countdown: state.countdown,
              isResetLinkSent: state.isResetLinkSent,
            ),
          );
        }
      } catch (e) {
        emit(
          AdminUnauthenticated(
            obscurePassword: state.obscurePassword,
            countdown: state.countdown,
            isResetLinkSent: state.isResetLinkSent,
          ),
        );
      }
    });

    // Admin Logout Requested
    on<AdminLogoutRequested>((event, emit) async {
      emit(
        AdminAuthLoading(
          obscurePassword: state.obscurePassword,
          countdown: state.countdown,
          isResetLinkSent: state.isResetLinkSent,
        ),
      );
      try {
        await logoutUseCase();
        emit(
          AdminUnauthenticated(
            obscurePassword: state.obscurePassword,
            countdown: state.countdown,
            isResetLinkSent: state.isResetLinkSent,
          ),
        );
      } catch (e) {
        emit(
          AdminUnauthenticated(
            obscurePassword: state.obscurePassword,
            countdown: state.countdown,
            isResetLinkSent: state.isResetLinkSent,
          ),
        );
      }
    });

    // Admin Password Reset Requested
    on<AdminPasswordResetRequested>((event, emit) async {
      emit(
        AdminAuthLoading(
          obscurePassword: state.obscurePassword,
          countdown: state.countdown,
          isResetLinkSent: state.isResetLinkSent,
        ),
      );
      try {
        await sendPasswordResetUseCase(event.email);
        emit(
          AdminAuthPasswordResetSent(
            obscurePassword: state.obscurePassword,
            countdown: 80,
            isResetLinkSent: true,
          ),
        );
        add(StartForgotPasswordCountdownEvent());
      } catch (e) {
        emit(
          AdminAuthFailure(
            _formatError(e),
            obscurePassword: state.obscurePassword,
            countdown: state.countdown,
            isResetLinkSent: state.isResetLinkSent,
          ),
        );
      }
    });

    // Admin Confirm Password Reset Requested
    on<AdminConfirmPasswordResetRequested>((event, emit) async {
      emit(
        AdminAuthLoading(
          obscurePassword: state.obscurePassword,
          countdown: state.countdown,
          isResetLinkSent: state.isResetLinkSent,
        ),
      );
      try {
        await confirmPasswordResetUseCase(
          code: event.code,
          newPassword: event.newPassword,
        );
        emit(
          AdminAuthPasswordResetSuccess(
            obscurePassword: state.obscurePassword,
            countdown: state.countdown,
            isResetLinkSent: state.isResetLinkSent,
          ),
        );
      } catch (e) {
        emit(
          AdminAuthFailure(
            _formatError(e),
            obscurePassword: state.obscurePassword,
            countdown: state.countdown,
            isResetLinkSent: state.isResetLinkSent,
          ),
        );
      }
    });

    // Admin Auth Session Verified
    on<AdminAuthSessionVerified>((event, emit) {
      if (event.isAuthenticated) {
        emit(
          AdminAuthSuccess(
            obscurePassword: state.obscurePassword,
            countdown: state.countdown,
            isResetLinkSent: state.isResetLinkSent,
          ),
        );
      } else {
        emit(
          AdminUnauthenticated(
            obscurePassword: state.obscurePassword,
            countdown: state.countdown,
            isResetLinkSent: state.isResetLinkSent,
          ),
        );
      }
    });

    // Password Toggle events handlers
    on<ToggleObscurePasswordEvent>((event, emit) {
      emit(state.copyWithToggledObscure());
    });

    // Start Forgot Password Countdown
    on<StartForgotPasswordCountdownEvent>((event, emit) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        add(DecrementForgotPasswordCountdownEvent());
      });
    });

    // Decrement Forgot Password Countdown
    on<DecrementForgotPasswordCountdownEvent>((event, emit) {
      if (state.countdown > 0) {
        emit(state.copyWithCountdown(state.countdown - 1));
      } else {
        _timer?.cancel();
        emit(state.copyWithExpired());
      }
    });

    // Reset Forgot Password Timer
    on<ResetForgotPasswordTimerEvent>((event, emit) {
      _timer?.cancel();
      emit(state.copyWithResetTimer());
    });
  }

  String _formatError(dynamic e) {
    final str = e.toString();
    final lower = str.toLowerCase();

    if (lower.contains('network') ||
        lower.contains('connection') ||
        lower.contains('offline') ||
        lower.contains('internet') ||
        lower.contains('timeout') ||
        lower.contains('failed to fetch')) {
      return 'No internet connection. Please check your network and try again.';
    }

    if (lower.contains('user-not-found') ||
        lower.contains('wrong-password') ||
        lower.contains('invalid-credential') ||
        lower.contains('incorrect email or password')) {
      return 'Incorrect email address or password.';
    }

    if (lower.contains('user-disabled')) {
      return 'This account has been disabled. Please contact support.';
    }

    if (lower.contains('too-many-requests')) {
      return 'Too many failed attempts. Please try again later.';
    }

    var clean = str
        .replaceAll(RegExp(r'^Exception:\s*'), '')
        .replaceAll(RegExp(r'\[firebase_auth/[^\]]+\]\s*'), '');

    return clean.trim().isNotEmpty
        ? clean.trim()
        : 'An unexpected authentication error occurred.';
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

// Helpers extension of AdminAuthState
extension AdminAuthStateHelpers on AdminAuthState {
  AdminAuthState copyWithToggledObscure() {
    final newObscure = !obscurePassword;
    return _createNewState(obscure: newObscure);
  }

  AdminAuthState copyWithCountdown(int newCountdown) {
    return _createNewState(cnt: newCountdown);
  }

  AdminAuthState copyWithExpired() {
    return AdminAuthPasswordResetExpired(
      obscurePassword: obscurePassword,
      countdown: 0,
      isResetLinkSent: false,
    );
  }

  AdminAuthState copyWithResetTimer() {
    return AdminAuthInitial(
      obscurePassword: obscurePassword,
      countdown: 80,
      isResetLinkSent: false,
    );
  }

  AdminAuthState _createNewState({bool? obscure, int? cnt, bool? resetSent}) {
    final obs = obscure ?? obscurePassword;
    final c = cnt ?? countdown;
    final r = resetSent ?? isResetLinkSent;

    if (this is AdminAuthInitial) {
      return AdminAuthInitial(
        obscurePassword: obs,
        countdown: c,
        isResetLinkSent: r,
      );
    } else if (this is AdminAuthLoading) {
      return AdminAuthLoading(
        obscurePassword: obs,
        countdown: c,
        isResetLinkSent: r,
      );
    } else if (this is AdminAuthSuccess) {
      return AdminAuthSuccess(
        obscurePassword: obs,
        countdown: c,
        isResetLinkSent: r,
      );
    } else if (this is AdminAuthFailure) {
      return AdminAuthFailure(
        (this as AdminAuthFailure).message,
        obscurePassword: obs,
        countdown: c,
        isResetLinkSent: r,
      );
    } else if (this is AdminUnauthenticated) {
      return AdminUnauthenticated(
        obscurePassword: obs,
        countdown: c,
        isResetLinkSent: r,
      );
    } else if (this is AdminAuthPasswordResetSent) {
      return AdminAuthPasswordResetSent(
        obscurePassword: obs,
        countdown: c,
        isResetLinkSent: r,
      );
    } else if (this is AdminAuthPasswordResetSuccess) {
      return AdminAuthPasswordResetSuccess(
        obscurePassword: obs,
        countdown: c,
        isResetLinkSent: r,
      );
    } else if (this is AdminAuthPasswordResetExpired) {
      return AdminAuthPasswordResetExpired(
        obscurePassword: obs,
        countdown: c,
        isResetLinkSent: r,
      );
    }
    return AdminAuthInitial(
      obscurePassword: obs,
      countdown: c,
      isResetLinkSent: r,
    );
  }
}
