import 'package:equatable/equatable.dart';

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

class ShopHomeError extends ShopHomeState {
  final String message;

  const ShopHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
