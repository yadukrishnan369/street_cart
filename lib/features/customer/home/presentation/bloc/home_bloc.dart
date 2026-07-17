import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/home/domain/usecases/get_home_data.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:street_cart/core/utils/logger.dart';

// Home Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeData getHomeData;

  HomeBloc({required this.getHomeData}) : super(const HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
    on<ResetHome>(_onResetHome);
    on<SelectCategory>(_onSelectCategory);
    on<ChangeBannerPage>(_onChangeBannerPage);
  }

  // fetches shop profiles and products based on user location
  Future<void> _onFetchHomeData(
    FetchHomeData event,
    Emitter<HomeState> emit,
  ) async {
    final currentCategory = state.selectedCategory;
    final currentBanner = state.currentBannerPage;

    if (state is! HomeLoaded) {
      emit(
        HomeLoading(
          selectedCategory: currentCategory,
          currentBannerPage: currentBanner,
        ),
      );
    }
    try {
      final homeData = await getHomeData();
      emit(
        HomeLoaded(
          homeData: homeData,
          selectedCategory: currentCategory,
          currentBannerPage: currentBanner,
        ),
      );
    } catch (e, stack) {
      AppLogger.error('Failed to fetch home data', e, stack);
      if (state is! HomeLoaded) {
        emit(
          HomeError(
            message: 'Failed to load home data',
            selectedCategory: currentCategory,
            currentBannerPage: currentBanner,
          ),
        );
      }
    }
  }

  // resets current state back to initial state
  void _onResetHome(ResetHome event, Emitter<HomeState> emit) {
    emit(const HomeInitial());
  }

  // handles category filter changes
  void _onSelectCategory(SelectCategory event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(selectedCategory: event.category));
    } else {
      emit(
        HomeInitial(
          selectedCategory: event.category,
          currentBannerPage: state.currentBannerPage,
        ),
      );
    }
  }

  // tracks page view slide
  void _onChangeBannerPage(ChangeBannerPage event, Emitter<HomeState> emit) {
    final currentState = state;
    if (currentState is HomeLoaded) {
      emit(currentState.copyWith(currentBannerPage: event.pageIndex));
    } else {
      emit(
        HomeInitial(
          selectedCategory: state.selectedCategory,
          currentBannerPage: event.pageIndex,
        ),
      );
    }
  }
}
