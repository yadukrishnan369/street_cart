import 'package:equatable/equatable.dart';

abstract class ShopOrdersEvent extends Equatable {
  const ShopOrdersEvent();

  @override
  List<Object?> get props => [];
}

class FetchShopOrdersEvent extends ShopOrdersEvent {
  final String shopId;

  const FetchShopOrdersEvent(this.shopId);

  @override
  List<Object?> get props => [shopId];
}

class UpdateOrderStatusEvent extends ShopOrdersEvent {
  final String shopId;
  final String orderId;
  final String newStatus;

  const UpdateOrderStatusEvent({
    required this.shopId,
    required this.orderId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [shopId, orderId, newStatus];
}
