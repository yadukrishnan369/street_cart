import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/get_shop_orders.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/update_shop_order_status.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/update_shop_order_return_status.dart';
part 'shop_orders_event.dart';
part 'shop_orders_state.dart';

class ShopOrdersBloc extends Bloc<ShopOrdersEvent, ShopOrdersState> {
  final GetShopOrders getShopOrders;
  final UpdateShopOrderStatus updateShopOrderStatus;
  final UpdateShopOrderReturnStatus updateShopOrderReturnStatus;

  ShopOrdersBloc({
    required this.getShopOrders,
    required this.updateShopOrderStatus,
    required this.updateShopOrderReturnStatus,
  }) : super(const ShopOrdersState()) {
    // Fetch orders
    on<FetchShopOrdersEvent>(_onFetchShopOrders);

    // Updates order status
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);

    // Updates return status
    on<UpdateOrderReturnStatusEvent>(_onUpdateOrderReturnStatus);

    // Toggles the COD cash payment received checkbox
    on<TogglePaymentReceivedEvent>((event, emit) {
      emit(state.copyWith(isPaymentReceived: event.isReceived));
    });
  }
  // Fetch Shop Orders
  Future<void> _onFetchShopOrders(
    FetchShopOrdersEvent event,
    Emitter<ShopOrdersState> emit,
  ) async {
    emit(state.copyWith(status: ShopOrdersStatus.loading));
    try {
      await emit.forEach<List>(
        getShopOrders(event.shopId),
        onData: (orders) => state.copyWith(
          status: ShopOrdersStatus.loaded,
          orders: orders.cast(),
        ),
        onError: (error, _) => state.copyWith(
          status: ShopOrdersStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopOrdersStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Update Order Status
  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<ShopOrdersState> emit,
  ) async {
    try {
      await updateShopOrderStatus(event.orderId, event.newStatus);
      // Reset payment received state
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopOrdersStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Update Order Return Status
  Future<void> _onUpdateOrderReturnStatus(
    UpdateOrderReturnStatusEvent event,
    Emitter<ShopOrdersState> emit,
  ) async {
    try {
      await updateShopOrderReturnStatus(event.orderId, event.newReturnStatus);
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopOrdersStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
