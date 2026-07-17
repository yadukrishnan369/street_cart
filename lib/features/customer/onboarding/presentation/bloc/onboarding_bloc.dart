import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/onboarding/domain/usecases/complete_onboarding.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

// Onboarding Bloc
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CompleteOnboarding completeOnboarding;

  OnboardingBloc({required this.completeOnboarding})
    : super(const OnboardingInitial()) {
    on<CompleteOnboardingEvent>(_onCompleteOnboarding);
    on<ChangeOnboardingPage>(_onChangeOnboardingPage);
  }

  // marks onboarding process as finished
  Future<void> _onCompleteOnboarding(
    CompleteOnboardingEvent event,
    Emitter<OnboardingState> emit,
  ) async {
    final page = state.currentPage;
    emit(OnboardingLoading(currentPage: page));
    try {
      await completeOnboarding();
      emit(OnboardingCompleted(currentPage: page));
    } catch (e) {
      emit(OnboardingError(e.toString(), currentPage: page));
    }
  }

  // updates state with the new slides page
  void _onChangeOnboardingPage(
    ChangeOnboardingPage event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingInitial(currentPage: event.pageIndex));
  }
}
