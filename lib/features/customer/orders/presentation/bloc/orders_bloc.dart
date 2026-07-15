import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/get_customer_orders.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/cancel_order.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/cancel_order_item.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/update_order_address.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetCustomerOrders getCustomerOrders;
  final CancelOrder cancelOrder;
  final CancelOrderItem cancelOrderItem;
  final UpdateOrderAddress updateOrderAddress;

  OrdersBloc({
    required this.getCustomerOrders,
    required this.cancelOrder,
    required this.cancelOrderItem,
    required this.updateOrderAddress,
  }) : super(OrdersInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<CancelOrderEvent>(_onCancelOrder);
    on<CancelOrderItemEvent>(_onCancelOrderItem);
    on<UpdateOrderAddressEvent>(_onUpdateOrderAddress);
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

  Future<void> _onCancelOrderItem(
    CancelOrderItemEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrderItemCancelling());
    try {
      await cancelOrderItem(event.orderId, event.orderItemId);
      emit(OrderItemCancelledSuccess());
    } catch (e) {
      emit(OrdersFailure(e.toString()));
    }
  }

  Future<void> _onUpdateOrderAddress(
    UpdateOrderAddressEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrderAddressUpdating());
    try {
      await updateOrderAddress(event.orderId, event.address);
      emit(OrderAddressUpdateSuccess());
    } catch (e) {
      emit(OrdersFailure(e.toString()));
    }
  }
}
