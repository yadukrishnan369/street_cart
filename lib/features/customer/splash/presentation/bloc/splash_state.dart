import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/splash/domain/repositories/i_splash_repository.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashLoaded extends SplashState {
  final AppStatus status;

  const SplashLoaded(this.status);

  @override
  List<Object?> get props => [status];
}

class SplashError extends SplashState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}
