part of 'shop_orders_bloc.dart';

enum ShopOrdersStatus { initial, loading, loaded, failure }

// State -  orders lists, loaded statuses, errors, and payment status
class ShopOrdersState extends Equatable {
  final ShopOrdersStatus status;
  final List<OrderModel> orders;
  final String? errorMessage;
  final bool isPaymentReceived;

  const ShopOrdersState({
    this.status = ShopOrdersStatus.initial,
    this.orders = const [],
    this.errorMessage,
    this.isPaymentReceived = false,
  });

  ShopOrdersState copyWith({
    ShopOrdersStatus? status,
    List<OrderModel>? orders,
    String? errorMessage,
    bool? isPaymentReceived,
  }) {
    return ShopOrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
      isPaymentReceived: isPaymentReceived ?? this.isPaymentReceived,
    );
  }

  @override
  List<Object?> get props => [status, orders, errorMessage, isPaymentReceived];
}
