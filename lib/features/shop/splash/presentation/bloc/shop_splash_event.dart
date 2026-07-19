import 'package:equatable/equatable.dart';

abstract class ShopSplashEvent extends Equatable {
  const ShopSplashEvent();

  @override
  List<Object?> get props => [];
}

// Check Shop App Status Event
class CheckShopAppStatusEvent extends ShopSplashEvent {}
