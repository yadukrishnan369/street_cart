import 'package:equatable/equatable.dart';

abstract class ShopLocationState extends Equatable {
  const ShopLocationState();

  @override
  List<Object?> get props => [];
}

class ShopLocationInitial extends ShopLocationState {}

class ShopLocationLoading extends ShopLocationState {}

class ShopLocationSuccess extends ShopLocationState {
  final bool success;

  const ShopLocationSuccess(this.success);

  @override
  List<Object?> get props => [success];
}

class ShopLocationSkipped extends ShopLocationState {}

class ShopLocationFailure extends ShopLocationState {
  final String message;

  const ShopLocationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
