import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/watch_shop_notifications.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/mark_shop_notification_as_read.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/mark_all_shop_notifications_as_read.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/delete_shop_notification.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/get_shop_order_details.dart';
import 'shop_notifications_event.dart';
import 'shop_notifications_state.dart';

class ShopNotificationsBloc
    extends Bloc<ShopNotificationsEvent, ShopNotificationsState> {
  final WatchShopNotifications _watchShopNotifications;
  final MarkShopNotificationAsRead _markShopNotificationAsRead;
  final MarkAllShopNotificationsAsRead _markAllShopNotificationsAsRead;
  final DeleteShopNotification _deleteShopNotification;
  final GetShopOrderDetails _getShopOrderDetails;
  StreamSubscription? _notificationsSubscription;

  ShopNotificationsBloc({
    required WatchShopNotifications watchShopNotifications,
    required MarkShopNotificationAsRead markShopNotificationAsRead,
    required MarkAllShopNotificationsAsRead markAllShopNotificationsAsRead,
    required DeleteShopNotification deleteShopNotification,
    required GetShopOrderDetails getShopOrderDetails,
  }) : _watchShopNotifications = watchShopNotifications,
       _markShopNotificationAsRead = markShopNotificationAsRead,
       _markAllShopNotificationsAsRead = markAllShopNotificationsAsRead,
       _deleteShopNotification = deleteShopNotification,
       _getShopOrderDetails = getShopOrderDetails,
       super(const ShopNotificationsState()) {
    on<LoadShopNotificationsEvent>(_onLoadNotifications);
    on<ShopNotificationsUpdatedEvent>(_onNotificationsUpdated);
    on<ShopNotificationsErrorEvent>(_onNotificationsError);
    on<MarkShopAsReadEvent>(_onMarkAsRead);
    on<MarkAllShopAsReadEvent>(_onMarkAllAsRead);
    on<GetShopOrderDetailsEvent>(_onGetOrderDetails);
    on<ClearShopSelectedOrderEvent>(_onClearSelectedOrder);
    on<GetShopProductDetailsEvent>(_onGetProductDetails);
    on<ClearShopSelectedProductEvent>(_onClearSelectedProduct);
    on<DeleteShopNotificationEvent>(_onDeleteNotification);
  }
  // Notifications Error
  void _onNotificationsError(
    ShopNotificationsErrorEvent event,
    Emitter<ShopNotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        status: ShopNotificationsStatus.failure,
        errorMessage: event.errorMessage,
      ),
    );
  }

  // Load Notifications
  void _onLoadNotifications(
    LoadShopNotificationsEvent event,
    Emitter<ShopNotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        status: ShopNotificationsStatus.loading,
        shopId: event.shopId,
      ),
    );
    _notificationsSubscription?.cancel();
    _notificationsSubscription = _watchShopNotifications(event.shopId).listen(
      (notifications) => add(ShopNotificationsUpdatedEvent(notifications)),
      onError: (error) {
        add(ShopNotificationsErrorEvent(error.toString()));
      },
    );
  }

  // Notifications Updated
  void _onNotificationsUpdated(
    ShopNotificationsUpdatedEvent event,
    Emitter<ShopNotificationsState> emit,
  ) {
    emit(
      state.copyWith(
        status: ShopNotificationsStatus.loaded,
        notifications: event.notifications,
      ),
    );
  }

  // Mark As Read
  Future<void> _onMarkAsRead(
    MarkShopAsReadEvent event,
    Emitter<ShopNotificationsState> emit,
  ) async {
    try {
      await _markShopNotificationAsRead(
        shopId: event.shopId,
        notificationId: event.notificationId,
      );
    } catch (_) {}
  }

  // Mark All As Read
  Future<void> _onMarkAllAsRead(
    MarkAllShopAsReadEvent event,
    Emitter<ShopNotificationsState> emit,
  ) async {
    try {
      await _markAllShopNotificationsAsRead(event.shopId);
    } catch (_) {}
  }

  // Get Order Details
  Future<void> _onGetOrderDetails(
    GetShopOrderDetailsEvent event,
    Emitter<ShopNotificationsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ShopNotificationsStatus.orderLoading,
        clearSelectedOrder: true,
        selectedNotificationId: event.notificationId,
      ),
    );
    try {
      final order = await _getShopOrderDetails(event.orderId);
      if (order != null) {
        emit(
          state.copyWith(
            status: ShopNotificationsStatus.orderLoaded,
            selectedOrder: order,
            isReturnOrder: event.isReturnOrder,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ShopNotificationsStatus.orderError,
            errorMessage: 'Order not found',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopNotificationsStatus.orderError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Clear Selected Order
  void _onClearSelectedOrder(
    ClearShopSelectedOrderEvent event,
    Emitter<ShopNotificationsState> emit,
  ) {
    emit(state.copyWith(clearSelectedOrder: true));
  }

  // Get Product Details
  Future<void> _onGetProductDetails(
    GetShopProductDetailsEvent event,
    Emitter<ShopNotificationsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: ShopNotificationsStatus.productLoading,
        clearSelectedProduct: true,
        selectedNotificationId: event.notificationId,
      ),
    );
    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(event.productId)
          .get();
      if (doc.exists && doc.data() != null) {
        final product = ProductModel.fromMap(doc.data()!, doc.id);
        emit(
          state.copyWith(
            status: ShopNotificationsStatus.productLoaded,
            selectedProduct: product,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ShopNotificationsStatus.productError,
            errorMessage: 'Product not found',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ShopNotificationsStatus.productError,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // Clear Selected Product
  void _onClearSelectedProduct(
    ClearShopSelectedProductEvent event,
    Emitter<ShopNotificationsState> emit,
  ) {
    emit(state.copyWith(clearSelectedProduct: true));
  }

  // Delete Notification
  Future<void> _onDeleteNotification(
    DeleteShopNotificationEvent event,
    Emitter<ShopNotificationsState> emit,
  ) async {
    try {
      await _deleteShopNotification(
        shopId: event.shopId,
        notificationId: event.notificationId,
      );
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
