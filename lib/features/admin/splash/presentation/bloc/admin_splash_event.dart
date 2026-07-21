import 'package:equatable/equatable.dart';

abstract class AdminSplashEvent extends Equatable {
  const AdminSplashEvent();

  @override
  List<Object?> get props => [];
}

// Starts loading animation Event
class StartSplashAnimation extends AdminSplashEvent {
  const StartSplashAnimation();
}

class SplashProgressTicked extends AdminSplashEvent {
  final double progress;
  final String loadingText;
  const SplashProgressTicked({
    required this.progress,
    required this.loadingText,
  });

  @override
  List<Object?> get props => [progress, loadingText];
}

// Session check Event
class CheckAdminSplashSessionEvent extends AdminSplashEvent {}
