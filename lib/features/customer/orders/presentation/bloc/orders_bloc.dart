import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/get_customer_orders.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/cancel_order.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetCustomerOrders getCustomerOrders;
  final CancelOrder cancelOrder;

  OrdersBloc({required this.getCustomerOrders, required this.cancelOrder})
    : super(OrdersInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<CancelOrderEvent>(_onCancelOrder);
  }

  Future<void> _onFetchOrders(
    FetchOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      await emit.forEach<List<OrderModel>>(
        getCustomerOrders(),
        onData: (orders) => OrdersLoaded(orders),
        onError: (error, _) => OrdersFailure(error.toString()),
      );
    } catch (e) {
      emit(OrdersFailure(e.toString()));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrderCancelling());
    try {
      await cancelOrder(event.orderId);
      emit(OrderCancelledSuccess());
    } catch (e) {
      emit(OrdersFailure(e.toString()));
    }
  }
}
