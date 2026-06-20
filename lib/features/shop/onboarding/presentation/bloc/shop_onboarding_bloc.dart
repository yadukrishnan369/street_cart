import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/onboarding/domain/usecases/complete_shop_onboarding.dart';
import 'shop_onboarding_event.dart';
import 'shop_onboarding_state.dart';

class ShopOnboardingBloc extends Bloc<ShopOnboardingEvent, ShopOnboardingState> {
  final CompleteShopOnboarding completeShopOnboarding;

  ShopOnboardingBloc({required this.completeShopOnboarding})
      : super(ShopOnboardingInitial()) {
    on<CompleteShopOnboardingEvent>((event, emit) async {
      emit(ShopOnboardingLoading());
      try {
        await completeShopOnboarding();
        emit(ShopOnboardingCompleted());
      } catch (e) {
        emit(ShopOnboardingError(e.toString()));
      }
    });
  }
}
