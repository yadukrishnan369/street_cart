import 'package:equatable/equatable.dart';

abstract class ShopOnboardingState extends Equatable {
  const ShopOnboardingState();

  @override
  List<Object?> get props => [];
}

class ShopOnboardingInitial extends ShopOnboardingState {}

class ShopOnboardingLoading extends ShopOnboardingState {}

class ShopOnboardingCompleted extends ShopOnboardingState {}

class ShopOnboardingError extends ShopOnboardingState {
  final String message;

  const ShopOnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}
