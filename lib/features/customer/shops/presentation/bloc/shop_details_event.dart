import 'package:equatable/equatable.dart';

abstract class ShopDetailsEvent extends Equatable {
  const ShopDetailsEvent();

  @override
  List<Object?> get props => [];
}

// Fetch Shop Event
class FetchShopProducts extends ShopDetailsEvent {
  final String shopId;

  const FetchShopProducts({required this.shopId});

  @override
  List<Object?> get props => [shopId];
}
