import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/notification/data/models/customer_notification_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

// Customer Notifications Status Enums
enum CustomerNotificationsStatus {
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

// Customer Notifications State
class CustomerNotificationsState extends Equatable {
  final CustomerNotificationsStatus status;
  final List<CustomerNotificationModel> notifications;
  final String userId;
  final OrderModel? selectedOrder;
  final ProductModel? selectedProduct;
  final ShopProfileModel? selectedShop;
  final String? selectedNotificationId;
  final String? errorMessage;

  const CustomerNotificationsState({
    this.status = CustomerNotificationsStatus.initial,
    this.notifications = const [],
    this.userId = '',
    this.selectedOrder,
    this.selectedProduct,
    this.selectedShop,
    this.selectedNotificationId,
    this.errorMessage,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  CustomerNotificationsState copyWith({
    CustomerNotificationsStatus? status,
    List<CustomerNotificationModel>? notifications,
    String? userId,
    OrderModel? selectedOrder,
    ProductModel? selectedProduct,
    ShopProfileModel? selectedShop,
    String? selectedNotificationId,
    bool clearSelectedOrder = false,
    bool clearSelectedProduct = false,
    String? errorMessage,
  }) {
    return CustomerNotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      userId: userId ?? this.userId,
      selectedOrder: clearSelectedOrder
          ? null
          : (selectedOrder ?? this.selectedOrder),
      selectedProduct: clearSelectedProduct
          ? null
          : (selectedProduct ?? this.selectedProduct),
      selectedShop: clearSelectedProduct
          ? null
          : (selectedShop ?? this.selectedShop),
      selectedNotificationId:
          selectedNotificationId ?? this.selectedNotificationId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    userId,
    selectedOrder,
    selectedProduct,
    selectedShop,
    selectedNotificationId,
    errorMessage,
  ];
}
