import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/get_customer_orders.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/cancel_order.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/cancel_order_item.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/update_order_address.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/submit_return_request.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/check_products_availability.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetCustomerOrders getCustomerOrders;
  final CancelOrder cancelOrder;
  final CancelOrderItem cancelOrderItem;
  final UpdateOrderAddress updateOrderAddress;
  final SubmitReturnRequest submitReturnRequest;
  final CheckProductsAvailability checkProductsAvailability;

  OrdersBloc({
    required this.getCustomerOrders,
    required this.cancelOrder,
    required this.cancelOrderItem,
    required this.updateOrderAddress,
    required this.submitReturnRequest,
    required this.checkProductsAvailability,
  }) : super(OrdersInitial()) {
    on<FetchOrders>(_onFetchOrders);
    on<CancelOrderEvent>(_onCancelOrder);
    on<CancelOrderItemEvent>(_onCancelOrderItem);
    on<UpdateOrderAddressEvent>(_onUpdateOrderAddress);
    on<SubmitReturnRequestEvent>(_onSubmitReturnRequest);
    on<VerifyReorderEvent>(_onVerifyReorder);
  }

  // Fetch Orders of Specific Customer
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

  // Cancel Order
  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrderCancelling());
    try {
      await cancelOrder(event.orderId);
      emit(OrderCancelledSuccess());
      add(FetchOrders());
    } catch (e) {
      emit(OrdersFailure(e.toString()));
    }
  }

  // Cancel Ordered Specific Product Item
  Future<void> _onCancelOrderItem(
    CancelOrderItemEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrderItemCancelling());
    try {
      await cancelOrderItem(event.orderId, event.orderItemId);
      emit(OrderItemCancelledSuccess());
      add(FetchOrders());
    } catch (e) {
      emit(OrdersFailure(e.toString()));
    }
  }

  // Update Delivery Address
  Future<void> _onUpdateOrderAddress(
    UpdateOrderAddressEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrderAddressUpdating());
    try {
      await updateOrderAddress(event.orderId, event.address);
      emit(OrderAddressUpdateSuccess());
      add(FetchOrders());
    } catch (e) {
      emit(OrdersFailure(e.toString()));
    }
  }

  // Submit Return Request
  Future<void> _onSubmitReturnRequest(
    SubmitReturnRequestEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(ReturnRequestSubmitting());
    try {
      await submitReturnRequest(
        orderId: event.orderId,
        itemId: event.itemId,
        reason: event.reason,
        details: event.details,
      );
      emit(ReturnRequestSubmittedSuccess());
      add(FetchOrders());
    } catch (e) {
      emit(OrdersFailure(e.toString()));
    }
  }

  // Verify Reorder Availability
  Future<void> _onVerifyReorder(
    VerifyReorderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final currentOrders = state is OrdersLoaded
        ? (state as OrdersLoaded).orders
        : <OrderModel>[];
    emit(ReorderVerifying(currentOrders));
    try {
      final errorsMap = await checkProductsAvailability(event.order.items);

      if (errorsMap.isNotEmpty) {
        final errorMsg = errorsMap.values.join('\n');
        emit(ReorderVerifyFailure(errorMsg, currentOrders));
      } else {
        emit(ReorderVerifySuccess(event.order, currentOrders));
      }
    } catch (e) {
      emit(OrdersFailure('Failed to verify products availability: $e'));
    }
  }
}
