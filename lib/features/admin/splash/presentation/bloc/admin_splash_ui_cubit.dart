import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSplashUiState {
  final double progress;
  final String loadingText;

  const AdminSplashUiState({
    this.progress = 0.0,
    this.loadingText = 'Initializing secure assets',
  });
}

class AdminSplashUiCubit extends Cubit<AdminSplashUiState> {
  AdminSplashUiCubit() : super(const AdminSplashUiState());

  Timer? _progressTimer;

  void startLoadingAnimation(void Function() onFinished) {
    _progressTimer?.cancel();
    const totalDuration = Duration(milliseconds: 2000);
    const tickDuration = Duration(milliseconds: 50);
    final ticks = totalDuration.inMilliseconds / tickDuration.inMilliseconds;
    double increment = 1.0 / ticks;

    _progressTimer = Timer.periodic(tickDuration, (timer) {
      double nextProgress = state.progress + increment;
      String nextText = state.loadingText;

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
        emit(AdminSplashUiState(progress: nextProgress, loadingText: nextText));
        onFinished();
      } else {
        emit(AdminSplashUiState(progress: nextProgress, loadingText: nextText));
      }
    });
  }

  @override
  Future<void> close() {
    _progressTimer?.cancel();
    return super.close();
  }
}
