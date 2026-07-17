import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  final int currentPage;

  const OnboardingState({this.currentPage = 0});

  @override
  List<Object?> get props => [currentPage];
}

// Initial state
class OnboardingInitial extends OnboardingState {
  const OnboardingInitial({super.currentPage});
}

// Loading state
class OnboardingLoading extends OnboardingState {
  const OnboardingLoading({required super.currentPage});
}

// State for onboarding completes successfully
class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted({required super.currentPage});
}

// State for onboarding completion error
class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message, {required super.currentPage});

  @override
  List<Object?> get props => [message, currentPage];
}
