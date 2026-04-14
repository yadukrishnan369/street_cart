import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/home/domain/usecases/get_home_address.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:street_cart/core/utils/logger.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeAddress getHomeAddress;

  HomeBloc({required this.getHomeAddress}) : super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(FetchHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final address = await getHomeAddress();
      emit(HomeLoaded(address: address));
    } catch (e, stack) {
      AppLogger.error('Failed to fetch home data', e, stack);
      emit(HomeError(message: 'Failed to load location'));
    }
  }
}
