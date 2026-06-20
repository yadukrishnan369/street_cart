import 'package:equatable/equatable.dart';

abstract class AdminSplashState extends Equatable {
  const AdminSplashState();

  @override
  List<Object?> get props => [];
}

class AdminSplashInitial extends AdminSplashState {}

class AdminSplashLoading extends AdminSplashState {}

class AdminSplashAuthenticated extends AdminSplashState {}

class AdminSplashUnauthenticated extends AdminSplashState {}

class AdminSplashError extends AdminSplashState {
  final String message;

  const AdminSplashError(this.message);

  @override
  List<Object?> get props => [message];
}
