part of 'shop_onboarding_bloc.dart';

// Base class
abstract class ShopOnboardingEvent extends Equatable {
  const ShopOnboardingEvent();

  @override
  List<Object?> get props => [];
}

// Event for when Shop completes the onboarding
class CompleteShopOnboardingEvent extends ShopOnboardingEvent {}

// Event for when Shop changes the page
class ShopOnboardingPageChangedEvent extends ShopOnboardingEvent {
  final int page;

  const ShopOnboardingPageChangedEvent(this.page);

  @override
  List<Object?> get props => [page];
}
