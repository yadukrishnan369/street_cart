import 'package:equatable/equatable.dart';

abstract class ShopLocationEvent extends Equatable {
  const ShopLocationEvent();

  @override
  List<Object?> get props => [];
}

// Request Location Enabled Event
class RequestShopLocationEvent extends ShopLocationEvent {}

// Skip Location Event
class SkipShopLocationEvent extends ShopLocationEvent {}
