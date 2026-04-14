import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressActionLoading extends AddressState {}

class AddressesLoaded extends AddressState {
  final List<AddressModel> addresses;
  const AddressesLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class AddressActionSuccess extends AddressState {
  final String message;
  const AddressActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AddressError extends AddressState {
  final String message;
  const AddressError(this.message);

  @override
  List<Object?> get props => [message];
}
