import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/get_shop_orders.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/update_shop_order_status.dart';
import 'shop_orders_event.dart';
import 'shop_orders_state.dart';

class ShopOrdersBloc extends Bloc<ShopOrdersEvent, ShopOrdersState> {
  final GetShopOrders getShopOrders;
  final UpdateShopOrderStatus updateShopOrderStatus;

  ShopOrdersBloc({
    required this.getShopOrders,
    required this.updateShopOrderStatus,
  }) : super(ShopOrdersInitial()) {
    on<FetchShopOrdersEvent>(_onFetchShopOrders);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
  }

  Future<void> _onFetchShopOrders(
    FetchShopOrdersEvent event,
    Emitter<ShopOrdersState> emit,
  ) async {
    emit(ShopOrdersLoading());
    try {
      // listens to the real time state
      await emit.forEach<List>(
        getShopOrders(event.shopId),
        onData: (orders) => ShopOrdersLoaded(orders.cast()),
        onError: (error, _) => ShopOrdersFailure(error.toString()),
      );
    } catch (e) {
      emit(ShopOrdersFailure(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<ShopOrdersState> emit,
  ) async {
    try {
      await updateShopOrderStatus(event.orderId, event.newStatus);
    } catch (e) {
      emit(ShopOrdersFailure(e.toString()));
    }
  }
}
