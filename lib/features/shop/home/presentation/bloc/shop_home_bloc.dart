import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/home/domain/usecases/check_first_home_visit.dart';
import 'package:street_cart/features/shop/home/domain/usecases/complete_first_home_visit.dart';
import 'package:street_cart/features/shop/home/domain/usecases/get_shop_dashboard_orders.dart';
import 'shop_home_event.dart';
import 'shop_home_state.dart';

class ShopHomeBloc extends Bloc<ShopHomeEvent, ShopHomeState> {
  final CheckFirstHomeVisit checkFirstHomeVisit;
  final CompleteFirstHomeVisit completeFirstHomeVisit;
  final GetShopDashboardOrders getShopDashboardOrders;

  ShopHomeBloc({
    required this.checkFirstHomeVisit,
    required this.completeFirstHomeVisit,
    required this.getShopDashboardOrders,
  }) : super(ShopHomeInitial()) {
    on<CheckFirstHomeVisitEvent>((event, emit) async {
      emit(ShopHomeLoading());
      try {
        final isFirstVisit = await checkFirstHomeVisit();
        emit(ShopHomeFirstVisitCheckCompleted(isFirstVisit));
      } catch (e) {
        emit(ShopHomeError(e.toString()));
      }
    });

    on<CompleteFirstHomeVisitEvent>((event, emit) async {
      emit(ShopHomeLoading());
      try {
        await completeFirstHomeVisit();
        emit(ShopHomeActionSuccess());
      } catch (e) {
        emit(ShopHomeError(e.toString()));
      }
    });

    on<FetchShopHomeDataEvent>((event, emit) async {
      if (state is! ShopHomeDataLoaded) {
        emit(ShopHomeLoading());
      }
      await emit.forEach(
        getShopDashboardOrders(event.shopId),
        onData: (orders) => ShopHomeDataLoaded(orders),
        onError: (e, _) => ShopHomeError(e.toString()),
      );
    });
  }
}
