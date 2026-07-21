import 'package:equatable/equatable.dart';

abstract class AdminSplashState extends Equatable {
  const AdminSplashState();

  @override
  List<Object?> get props => [];
}

class AdminSplashInitial extends AdminSplashState {}

// Animated progress loading text State
class AdminSplashAnimating extends AdminSplashState {
  final double progress;
  final String loadingText;

  const AdminSplashAnimating({
    this.progress = 0.0,
    this.loadingText = 'Initializing secure assets',
  });

  @override
  List<Object?> get props => [progress, loadingText];
}

// Splash Loading State
class AdminSplashLoading extends AdminSplashState {}

// Splash Authenticated State
class AdminSplashAuthenticated extends AdminSplashState {}

// Splash Unauthenticated State
class AdminSplashUnauthenticated extends AdminSplashState {}

// Splash Error State
class AdminSplashError extends AdminSplashState {
  final String message;

  const AdminSplashError(this.message);

  @override
  List<Object?> get props => [message];
}
