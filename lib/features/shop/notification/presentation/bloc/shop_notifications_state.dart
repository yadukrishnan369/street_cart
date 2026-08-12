import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/notification/data/models/shop_notification_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

// Shop Notifications Status Enums
enum ShopNotificationsStatus {
  initial,
  loading,
  loaded,
  failure,
  orderLoading,
  orderLoaded,
  orderError,
  productLoading,
  productLoaded,
  productError,
}

// Shop Notifications State
class ShopNotificationsState extends Equatable {
  final ShopNotificationsStatus status;
  final List<ShopNotificationModel> notifications;
  final String shopId;
  final OrderModel? selectedOrder;
  final ProductModel? selectedProduct;
  final bool isReturnOrder;
  final String? selectedNotificationId;
  final String? errorMessage;

  const ShopNotificationsState({
    this.status = ShopNotificationsStatus.initial,
    this.notifications = const [],
    this.shopId = '',
    this.selectedOrder,
    this.selectedProduct,
    this.isReturnOrder = false,
    this.selectedNotificationId,
    this.errorMessage,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  ShopNotificationsState copyWith({
    ShopNotificationsStatus? status,
    List<ShopNotificationModel>? notifications,
    String? shopId,
    OrderModel? selectedOrder,
    ProductModel? selectedProduct,
    bool? isReturnOrder,
    String? selectedNotificationId,
    bool clearSelectedOrder = false,
    bool clearSelectedProduct = false,
    String? errorMessage,
  }) {
    return ShopNotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      shopId: shopId ?? this.shopId,
      selectedOrder: clearSelectedOrder
          ? null
          : (selectedOrder ?? this.selectedOrder),
      selectedProduct: clearSelectedProduct
          ? null
          : (selectedProduct ?? this.selectedProduct),
      isReturnOrder: isReturnOrder ?? this.isReturnOrder,
      selectedNotificationId:
          selectedNotificationId ?? this.selectedNotificationId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    shopId,
    selectedOrder,
    selectedProduct,
    isReturnOrder,
    selectedNotificationId,
    errorMessage,
  ];
}
