import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/location/domain/usecases/request_shop_location_and_save.dart';
import 'shop_location_event.dart';
import 'shop_location_state.dart';

class ShopLocationBloc extends Bloc<ShopLocationEvent, ShopLocationState> {
  final RequestShopLocationAndSave requestLocationAndSave;
  final SkipShopLocation skipLocation;

  ShopLocationBloc({
    required this.requestLocationAndSave,
    required this.skipLocation,
  }) : super(ShopLocationInitial()) {
    // Location Request
    on<RequestShopLocationEvent>((event, emit) async {
      // Loading State
      emit(ShopLocationLoading());
      try {
        final success = await requestLocationAndSave();
        // Location Enable Success State
        emit(ShopLocationSuccess(success));
      } catch (e) {
        // Location Failure
        emit(ShopLocationFailure(e.toString()));
      }
    });

    // Skip Location
    on<SkipShopLocationEvent>((event, emit) async {
      emit(ShopLocationLoading());
      try {
        await skipLocation();
        emit(ShopLocationSkipped());
      } catch (e) {
        emit(ShopLocationFailure(e.toString()));
      }
    });
  }
}
