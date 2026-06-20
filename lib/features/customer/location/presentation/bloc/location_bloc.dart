import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/location/domain/usecases/request_location_and_save.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final RequestLocationAndSave requestLocationAndSave;
  final SkipLocation skipLocation;

  LocationBloc({
    required this.requestLocationAndSave,
    required this.skipLocation,
  }) : super(LocationInitial()) {
    on<RequestLocationEvent>((event, emit) async {
      emit(LocationLoading());
      try {
        final success = await requestLocationAndSave();
        emit(LocationSuccess(success));
      } catch (e) {
        emit(LocationFailure(e.toString()));
      }
    });

    on<SkipLocationEvent>((event, emit) async {
      emit(LocationLoading());
      try {
        await skipLocation();
        emit(LocationSkipped());
      } catch (e) {
        emit(LocationFailure(e.toString()));
      }
    });
  }
}
