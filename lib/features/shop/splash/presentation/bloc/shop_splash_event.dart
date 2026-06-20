import 'package:equatable/equatable.dart';

abstract class ShopSplashEvent extends Equatable {
  const ShopSplashEvent();

  @override
  List<Object?> get props => [];
}

class CheckShopAppStatusEvent extends ShopSplashEvent {}
