import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/splash/domain/usecases/check_shop_app_status.dart';
import 'shop_splash_event.dart';
import 'shop_splash_state.dart';

class ShopSplashBloc extends Bloc<ShopSplashEvent, ShopSplashState> {
  final CheckShopAppStatus checkShopAppStatus;

  ShopSplashBloc({required this.checkShopAppStatus})
    : super(ShopSplashInitial()) {
    on<CheckShopAppStatusEvent>((event, emit) async {
      emit(ShopSplashLoading());
      try {
        final status = await checkShopAppStatus();
        emit(ShopSplashLoaded(status));
      } catch (e) {
        emit(ShopSplashError(e.toString()));
      }
    });
  }
}
