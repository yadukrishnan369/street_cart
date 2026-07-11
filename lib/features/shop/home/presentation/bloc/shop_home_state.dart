import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

abstract class ShopHomeState extends Equatable {
  const ShopHomeState();

  @override
  List<Object?> get props => [];
}

class ShopHomeInitial extends ShopHomeState {}

class ShopHomeLoading extends ShopHomeState {}

class ShopHomeFirstVisitCheckCompleted extends ShopHomeState {
  final bool isFirstVisit;

  const ShopHomeFirstVisitCheckCompleted(this.isFirstVisit);

  @override
  List<Object?> get props => [isFirstVisit];
}

class ShopHomeActionSuccess extends ShopHomeState {}

class ShopHomeDataLoaded extends ShopHomeState {
  final List<OrderModel> orders;

  const ShopHomeDataLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class ShopHomeError extends ShopHomeState {
  final String message;

  const ShopHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
