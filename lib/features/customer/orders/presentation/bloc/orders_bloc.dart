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
    if (state is OrdersInitial) {
      emit(OrdersLoading());
    }
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
    final currentOrders = state is OrdersLoaded
        ? (state as OrdersLoaded).orders
        : <OrderModel>[];
    emit(OrderCancelling(currentOrders));
    try {
      await cancelOrder(event.orderId);
      final updatedOrders = currentOrders.map((order) {
        if (order.id == event.orderId) {
          final updatedItems = order.items.map((item) {
            return item.copyWith(status: 'cancelled');
          }).toList();
          return order.copyWith(
            status: 'cancelled',
            items: updatedItems,
            cancelledAt: DateTime.now(),
          );
        }
        return order;
      }).toList();
      emit(OrderCancelledSuccess(updatedOrders));
    } catch (e) {
      emit(OrdersFailure(e.toString()));
    }
  }

  // Cancel Ordered Specific Product Item
  Future<void> _onCancelOrderItem(
    CancelOrderItemEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final currentOrders = state is OrdersLoaded
        ? (state as OrdersLoaded).orders
        : <OrderModel>[];
    emit(OrderItemCancelling(currentOrders));
    try {
      await cancelOrderItem(event.orderId, event.orderItemId);
      final updatedOrders = currentOrders.map((order) {
        if (order.id == event.orderId) {
          final updatedItems = order.items.map((item) {
            if (item.id == event.orderItemId) {
              return item.copyWith(status: 'cancelled');
            }
            return item;
          }).toList();
          final allCancelled = updatedItems.every(
            (item) => (item.status ?? '') == 'cancelled',
          );
          return order.copyWith(
            status: allCancelled ? 'cancelled' : order.status,
            items: updatedItems,
            cancelledAt: allCancelled ? DateTime.now() : order.cancelledAt,
          );
        }
        return order;
      }).toList();
      emit(OrderItemCancelledSuccess(updatedOrders));
    } catch (e) {
      emit(OrdersFailure(e.toString()));
    }
  }

  // Update Delivery Address
  Future<void> _onUpdateOrderAddress(
    UpdateOrderAddressEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final currentOrders = state is OrdersLoaded
        ? (state as OrdersLoaded).orders
        : <OrderModel>[];
    emit(OrderAddressUpdating(currentOrders));
    try {
      await updateOrderAddress(event.orderId, event.address);
      emit(OrderAddressUpdateSuccess(currentOrders));
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
