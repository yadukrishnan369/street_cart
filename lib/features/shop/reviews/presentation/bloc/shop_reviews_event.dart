import 'package:equatable/equatable.dart';

abstract class ShopReviewsEvent extends Equatable {
  const ShopReviewsEvent();

  @override
  List<Object?> get props => [];
}

// Load Shop Reviews Event
class LoadShopReviewsEvent extends ShopReviewsEvent {
  final String productId;

  const LoadShopReviewsEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}
