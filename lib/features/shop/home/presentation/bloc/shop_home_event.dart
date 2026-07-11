import 'package:equatable/equatable.dart';

abstract class ShopHomeEvent extends Equatable {
  const ShopHomeEvent();

  @override
  List<Object?> get props => [];
}

class CheckFirstHomeVisitEvent extends ShopHomeEvent {}

class CompleteFirstHomeVisitEvent extends ShopHomeEvent {}

class FetchShopHomeDataEvent extends ShopHomeEvent {
  final String shopId;

  const FetchShopHomeDataEvent(this.shopId);

  @override
  List<Object?> get props => [shopId];
}
