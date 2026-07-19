part of 'shop_onboarding_bloc.dart';

// Statuses of onboarding workflow
enum ShopOnboardingStatus { initial, loading, completed, error }

// Onboarding states, loading states, error, active page
class ShopOnboardingState extends Equatable {
  final ShopOnboardingStatus status;
  final String? errorMessage;
  final int currentPage;

  const ShopOnboardingState({
    this.status = ShopOnboardingStatus.initial,
    this.errorMessage,
    this.currentPage = 0,
  });

  ShopOnboardingState copyWith({
    ShopOnboardingStatus? status,
    String? errorMessage,
    int? currentPage,
  }) {
    return ShopOnboardingState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, currentPage];
}
