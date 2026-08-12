import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/watch_customer_notifications.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/mark_customer_notification_as_read.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/mark_all_customer_notifications_as_read.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/get_customer_order_details.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/get_customer_product_details.dart';
import 'customer_notifications_event.dart';
import 'customer_notifications_state.dart';

class CustomerNotificationsBloc
    extends Bloc<CustomerNotificationsEvent, CustomerNotificationsState> {
  final WatchCustomerNotifications _watchCustomerNotifications;
  final MarkCustomerNotificationAsRead _markCustomerNotificationAsRead;
  final MarkAllCustomerNotificationsAsRead _markAllCustomerNotificationsAsRead;
  final GetCustomerOrderDetails _getCustomerOrderDetails;
  final GetCustomerProductDetails _getCustomerProductDetails;
  StreamSubscription? _notificationsSubscription;

  CustomerNotificationsBloc({
    required WatchCustomerNotifications watchCustomerNotifications,
    required MarkCustomerNotificationAsRead markCustomerNotificationAsRead,
    required MarkAllCustomerNotificationsAsRead
    markAllCustomerNotificationsAsRead,
    required GetCustomerOrderDetails getCustomerOrderDetails,
    required GetCustomerProductDetails getCustomerProductDetails,
  }) : _watchCustomerNotifications = watchCustomerNotifications,
       _markCustomerNotificationAsRead = markCustomerNotificationAsRead,
       _markAllCustomerNotificationsAsRead = markAllCustomerNotificationsAsRead,
       _getCustomerOrderDetails = getCustomerOrderDetails,
       _getCustomerProductDetails = getCustomerProductDetails,
       super(const CustomerNotificationsState()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<NotificationsUpdatedEvent>(_onNotificationsUpdated);
    on<CustomerNotificationsErrorEvent>(_onNotificationsError);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
    on<GetOrderDetailsEvent>(_onGetOrderDetails);
    on<ClearSelectedOrderEvent>(_onClearSelectedOrder);
    on<GetProductDetailsEvent>(_onGetProductDetails);
    on<ClearSelectedProductEvent>(_onClearSelectedProduct);
  }
  // Notifications Error
  void _onNotificationsError(
    CustomerNotificationsErrorEvent event,
    Emitter<CustomerNotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        status: CustomerNotificationsStatus.failure,
        errorMessage: event.errorMessage,
      ),
    );
  }

  // Load Notifications
  void _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<CustomerNotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        status: CustomerNotificationsStatus.loading,
        userId: event.userId,
      ),
    );
    _notificationsSubscription?.cancel();
    _notificationsSubscription = _watchCustomerNotifications(event.userId)
        .listen(
          (notifications) => add(NotificationsUpdatedEvent(notifications)),
          onError: (error) {
            add(CustomerNotificationsErrorEvent(error.toString()));
          },
        );
  }

  // Notifications Updated
  void _onNotificationsUpdated(
    NotificationsUpdatedEvent event,
    Emitter<CustomerNotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        status: CustomerNotificationsStatus.loaded,
        notifications: event.notifications,
      ),
    );
  }

  // Mark As Read
  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<CustomerNotificationsState> emit,
  ) async {
    try {
      await _markCustomerNotificationAsRead(
        userId: event.userId,
        notificationId: event.notificationId,
      );
    } catch (_) {}
  }

  // Mark All As Read
  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<CustomerNotificationsState> emit,
  ) async {
    try {
      await _markAllCustomerNotificationsAsRead(event.userId);
    } catch (_) {}
  }

  // Get Order Details
  Future<void> _onGetOrderDetails(
    GetOrderDetailsEvent event,
    Emitter<CustomerNotificationsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CustomerNotificationsStatus.orderLoading,
        clearSelectedOrder: true,
        selectedNotificationId: event.notificationId,
      ),
    );
    try {
      final order = await _getCustomerOrderDetails(event.orderId);
      if (order != null) {
        emit(
          state.copyWith(
            status: CustomerNotificationsStatus.orderLoaded,
            selectedOrder: order,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CustomerNotificationsStatus.orderError,
            errorMessage: 'Order not found',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CustomerNotificationsStatus.orderError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Clear Selected Order
  void _onClearSelectedOrder(
    ClearSelectedOrderEvent event,
    Emitter<CustomerNotificationsState> emit,
  ) {
    emit(state.copyWith(clearSelectedOrder: true));
  }

  // Get Product Details
  Future<void> _onGetProductDetails(
    GetProductDetailsEvent event,
    Emitter<CustomerNotificationsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CustomerNotificationsStatus.productLoading,
        clearSelectedProduct: true,
        selectedNotificationId: event.notificationId,
      ),
    );
    try {
      final result = await _getCustomerProductDetails(event.productId);
      if (result != null) {
        emit(
          state.copyWith(
            status: CustomerNotificationsStatus.productLoaded,
            selectedProduct: result.product,
            selectedShop: result.shop,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: CustomerNotificationsStatus.productError,
            errorMessage: 'Product not found',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CustomerNotificationsStatus.productError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Clear Selected Product
  void _onClearSelectedProduct(
    ClearSelectedProductEvent event,
    Emitter<CustomerNotificationsState> emit,
  ) {
    emit(state.copyWith(clearSelectedProduct: true));
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
