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

  AdminAuthBloc({
    required this.loginUseCase,
    required this.checkSessionUseCase,
    required this.logoutUseCase,
    required this.sendPasswordResetUseCase,
    required this.confirmPasswordResetUseCase,
  }) : super(AdminAuthInitial()) {
    on<AdminLoginRequested>((event, emit) async {
      emit(AdminAuthLoading());
      try {
        final success = await loginUseCase(
          email: event.email,
          password: event.password,
        );
        if (success) {
          emit(AdminAuthSuccess());
        } else {
          emit(const AdminAuthFailure('Authentication failed.'));
        }
      } catch (e) {
        emit(AdminAuthFailure(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<CheckAdminSessionRequested>((event, emit) async {
      emit(AdminAuthLoading());
      try {
        final success = await checkSessionUseCase();
        if (success) {
          emit(AdminAuthSuccess());
        } else {
          emit(AdminUnauthenticated());
        }
      } catch (e) {
        emit(AdminUnauthenticated());
      }
    });

    on<AdminLogoutRequested>((event, emit) async {
      emit(AdminAuthLoading());
      try {
        await logoutUseCase();
        emit(AdminUnauthenticated());
      } catch (e) {
        emit(AdminUnauthenticated());
      }
    });

    on<AdminPasswordResetRequested>((event, emit) async {
      emit(AdminAuthLoading());
      try {
        await sendPasswordResetUseCase(event.email);
        emit(AdminAuthPasswordResetSent());
      } catch (e) {
        emit(AdminAuthFailure(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<AdminConfirmPasswordResetRequested>((event, emit) async {
      emit(AdminAuthLoading());
      try {
        await confirmPasswordResetUseCase(
          code: event.code,
          newPassword: event.newPassword,
        );
        emit(AdminAuthPasswordResetSuccess());
      } catch (e) {
        emit(AdminAuthFailure(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<AdminAuthSessionVerified>((event, emit) {
      if (event.isAuthenticated) {
        emit(AdminAuthSuccess());
      } else {
        emit(AdminUnauthenticated());
      }
    });
  }
}
