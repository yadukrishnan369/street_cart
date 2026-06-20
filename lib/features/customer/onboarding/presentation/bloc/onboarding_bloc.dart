import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/onboarding/domain/usecases/complete_onboarding.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final CompleteOnboarding completeOnboarding;

  OnboardingBloc({required this.completeOnboarding}) : super(OnboardingInitial()) {
    on<CompleteOnboardingEvent>((event, emit) async {
      emit(OnboardingLoading());
      try {
        await completeOnboarding();
        emit(OnboardingCompleted());
      } catch (e) {
        emit(OnboardingError(e.toString()));
      }
    });
  }
}
