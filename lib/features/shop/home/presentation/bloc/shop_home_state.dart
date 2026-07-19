import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

abstract class ShopHomeState extends Equatable {
  const ShopHomeState();

  @override
  List<Object?> get props => [];
}

// Intital State
class ShopHomeInitial extends ShopHomeState {}

// Loading State
class ShopHomeLoading extends ShopHomeState {}

// First Visit Completed State
class ShopHomeFirstVisitCheckCompleted extends ShopHomeState {
  final bool isFirstVisit;

  const ShopHomeFirstVisitCheckCompleted(this.isFirstVisit);

  @override
  List<Object?> get props => [isFirstVisit];
}

// Action succes State
class ShopHomeActionSuccess extends ShopHomeState {}

// Home Loaded State
class ShopHomeDataLoaded extends ShopHomeState {
  final List<OrderModel> orders;

  const ShopHomeDataLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

// Shop Error State
class ShopHomeError extends ShopHomeState {
  final String message;

  const ShopHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
