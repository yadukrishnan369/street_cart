import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/admin/splash/domain/usecases/check_admin_splash_session.dart';
import 'admin_splash_event.dart';
import 'admin_splash_state.dart';

class AdminSplashBloc extends Bloc<AdminSplashEvent, AdminSplashState> {
  final CheckAdminSplashSession checkAdminSplashSession;

  AdminSplashBloc({required this.checkAdminSplashSession})
      : super(AdminSplashInitial()) {
    on<CheckAdminSplashSessionEvent>((event, emit) async {
      emit(AdminSplashLoading());
      try {
        final success = await checkAdminSplashSession();
        if (success) {
          emit(AdminSplashAuthenticated());
        } else {
          emit(AdminSplashUnauthenticated());
        }
      } catch (e) {
        emit(AdminSplashError(e.toString()));
      }
    });
  }
}
