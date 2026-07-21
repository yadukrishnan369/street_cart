import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/splash/domain/usecases/check_admin_splash_session.dart';
import 'admin_splash_event.dart';
import 'admin_splash_state.dart';

class AdminSplashBloc extends Bloc<AdminSplashEvent, AdminSplashState> {
  final CheckAdminSplashSession checkAdminSplashSession;

  Timer? _progressTimer;

  AdminSplashBloc({required this.checkAdminSplashSession})
    : super(AdminSplashInitial()) {
    on<StartSplashAnimation>(_onStartSplashAnimation);
    on<SplashProgressTicked>(_onSplashProgressTicked);
    on<CheckAdminSplashSessionEvent>(_onCheckAdminSplashSession);
  }

  // Starts the progress bar animation
  Future<void> _onStartSplashAnimation(
    StartSplashAnimation event,
    Emitter<AdminSplashState> emit,
  ) async {
    _progressTimer?.cancel();
    emit(const AdminSplashAnimating());

    const totalDuration = Duration(milliseconds: 2000);
    const tickDuration = Duration(milliseconds: 50);
    final ticks = totalDuration.inMilliseconds / tickDuration.inMilliseconds;
    final increment = 1.0 / ticks;

    _progressTimer = Timer.periodic(tickDuration, (timer) {
      final current = state is AdminSplashAnimating
          ? (state as AdminSplashAnimating).progress
          : 0.0;

      double nextProgress = current + increment;
      String nextText = 'Initializing secure assets';

      if (nextProgress >= 0.35 && nextProgress < 0.7) {
        nextText = 'Loading system configurations';
      } else if (nextProgress >= 0.7 && nextProgress < 0.9) {
        nextText = 'Verifying admin credentials';
      } else if (nextProgress >= 0.9) {
        nextText = 'Launching dashboard';
      }

      if (nextProgress >= 1.0) {
        nextProgress = 1.0;
        timer.cancel();
        add(
          SplashProgressTicked(progress: nextProgress, loadingText: nextText),
        );
        // Animation complete and session check
        add(CheckAdminSplashSessionEvent());
      } else {
        add(
          SplashProgressTicked(progress: nextProgress, loadingText: nextText),
        );
      }
    });
  }

  // Updates the animating state
  void _onSplashProgressTicked(
    SplashProgressTicked event,
    Emitter<AdminSplashState> emit,
  ) {
    emit(
      AdminSplashAnimating(
        progress: event.progress,
        loadingText: event.loadingText,
      ),
    );
  }

  // Checks admin session after animation completes
  Future<void> _onCheckAdminSplashSession(
    CheckAdminSplashSessionEvent event,
    Emitter<AdminSplashState> emit,
  ) async {
    emit(AdminSplashLoading());
    try {
      final success = await checkAdminSplashSession();
      if (success) {
        emit(AdminSplashAuthenticated());
      } else {
        emit(AdminSplashUnauthenticated());
      }
    } catch (e) {
      emit(AdminSplashError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _progressTimer?.cancel();
    return super.close();
  }
}
