import 'package:equatable/equatable.dart';

abstract class ShopLocationState extends Equatable {
  const ShopLocationState();

  @override
  List<Object?> get props => [];
}

// Initial State
class ShopLocationInitial extends ShopLocationState {}

//  Loading State
class ShopLocationLoading extends ShopLocationState {}

// Location Success State
class ShopLocationSuccess extends ShopLocationState {
  final bool success;

  const ShopLocationSuccess(this.success);

  @override
  List<Object?> get props => [success];
}

// Location Skip State
class ShopLocationSkipped extends ShopLocationState {}

// Location Failure State
class ShopLocationFailure extends ShopLocationState {
  final String message;

  const ShopLocationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
