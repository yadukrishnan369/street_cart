import 'package:street_cart/features/customer/home/domain/repositories/i_home_repository.dart';

// Base state class
abstract class HomeState {
  final String selectedCategory;
  final int currentBannerPage;

  const HomeState({
    required this.selectedCategory,
    required this.currentBannerPage,
  });
}

// Initial default state
class HomeInitial extends HomeState {
  const HomeInitial({
    super.selectedCategory = 'All',
    super.currentBannerPage = 0,
  });
}

//  Home Loading State
class HomeLoading extends HomeState {
  const HomeLoading({
    required super.selectedCategory,
    required super.currentBannerPage,
  });
}

// Home Loaded State
class HomeLoaded extends HomeState {
  final HomeData homeData;

  const HomeLoaded({
    required this.homeData,
    required super.selectedCategory,
    required super.currentBannerPage,
  });

  HomeLoaded copyWith({
    HomeData? homeData,
    String? selectedCategory,
    int? currentBannerPage,
  }) {
    return HomeLoaded(
      homeData: homeData ?? this.homeData,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentBannerPage: currentBannerPage ?? this.currentBannerPage,
    );
  }
}

// Home Error State
class HomeError extends HomeState {
  final String message;

  const HomeError({
    required this.message,
    required super.selectedCategory,
    required super.currentBannerPage,
  });
}
