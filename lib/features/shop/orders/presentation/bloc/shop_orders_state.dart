part of 'shop_orders_bloc.dart';

enum ShopOrdersStatus { initial, loading, loaded, failure }

// State -  orders lists, loaded statuses, errors, and payment status
class ShopOrdersState extends Equatable {
  final ShopOrdersStatus status;
  final List<OrderModel> orders;
  final String? errorMessage;
  final bool isPaymentReceived;
  final String refundStatus;
  final String? refundError;
  final bool isRefundViaHand;
  final Map<String, Map<String, bool>> productStatusMap;

  const ShopOrdersState({
    this.status = ShopOrdersStatus.initial,
    this.orders = const [],
    this.errorMessage,
    this.isPaymentReceived = false,
    this.refundStatus = 'initial',
    this.refundError,
    this.isRefundViaHand = false,
    this.productStatusMap = const {},
  });

  ShopOrdersState copyWith({
    ShopOrdersStatus? status,
    List<OrderModel>? orders,
    String? errorMessage,
    bool? isPaymentReceived,
    String? refundStatus,
    String? refundError,
    bool? isRefundViaHand,
    Map<String, Map<String, bool>>? productStatusMap,
  }) {
    return ShopOrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
      isPaymentReceived: isPaymentReceived ?? this.isPaymentReceived,
      refundStatus: refundStatus ?? this.refundStatus,
      refundError: refundError ?? this.refundError,
      isRefundViaHand: isRefundViaHand ?? this.isRefundViaHand,
      productStatusMap: productStatusMap ?? this.productStatusMap,
    );
  }

  @override
  List<Object?> get props => [
    status,
    orders,
    errorMessage,
    isPaymentReceived,
    refundStatus,
    refundError,
    isRefundViaHand,
    productStatusMap,
  ];
}
