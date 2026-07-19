import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/onboarding/domain/usecases/complete_shop_onboarding.dart';
part 'shop_onboarding_event.dart';
part 'shop_onboarding_state.dart';

class ShopOnboardingBloc
    extends Bloc<ShopOnboardingEvent, ShopOnboardingState> {
  final CompleteShopOnboarding completeShopOnboarding;

  ShopOnboardingBloc({required this.completeShopOnboarding})
    : super(const ShopOnboardingState()) {
    //  When Shop change pages in PageView
    on<ShopOnboardingPageChangedEvent>((event, emit) {
      emit(state.copyWith(currentPage: event.page));
    });

    // When Shop completes onboarding
    on<CompleteShopOnboardingEvent>((event, emit) async {
      emit(state.copyWith(status: ShopOnboardingStatus.loading));
      try {
        await completeShopOnboarding();
        emit(state.copyWith(status: ShopOnboardingStatus.completed));
      } catch (e) {
        emit(
          state.copyWith(
            status: ShopOnboardingStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }
}
