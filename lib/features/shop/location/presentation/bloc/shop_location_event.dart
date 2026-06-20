import 'package:equatable/equatable.dart';

abstract class ShopLocationEvent extends Equatable {
  const ShopLocationEvent();

  @override
  List<Object?> get props => [];
}

class RequestShopLocationEvent extends ShopLocationEvent {}

class SkipShopLocationEvent extends ShopLocationEvent {}
