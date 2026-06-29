import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/home/domain/usecases/get_home_data.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:street_cart/core/utils/logger.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeData getHomeData;

  HomeBloc({required this.getHomeData}) : super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(FetchHomeData event, Emitter<HomeState> emit) async {
    if (state is! HomeLoaded) {
      emit(HomeLoading());
    }
    try {
      final homeData = await getHomeData();
      emit(HomeLoaded(homeData: homeData));
    } catch (e, stack) {
      AppLogger.error('Failed to fetch home data', e, stack);
      if (state is! HomeLoaded) {
        emit(HomeError(message: 'Failed to load home data'));
      }
    }
  }
}
