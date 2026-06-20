import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/splash/domain/usecases/check_app_status.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckAppStatus checkAppStatus;

  SplashBloc({required this.checkAppStatus}) : super(SplashInitial()) {
    on<CheckAppStatusEvent>((event, emit) async {
      emit(SplashLoading());
      try {
        final status = await checkAppStatus();
        emit(SplashLoaded(status));
      } catch (e) {
        emit(SplashError(e.toString()));
      }
    });
  }
}
