import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

// Event For continue to proceed in onboarding
class CompleteOnboardingEvent extends OnboardingEvent {}

// Event For Move another page in onboarding
class ChangeOnboardingPage extends OnboardingEvent {
  final int pageIndex;

  const ChangeOnboardingPage(this.pageIndex);

  @override
  List<Object?> get props => [pageIndex];
}
