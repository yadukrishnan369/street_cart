import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class FetchAddresses extends AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final AddressModel address;
  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateAddressEvent extends AddressEvent {
  final AddressModel address;
  const UpdateAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

class DeleteAddressEvent extends AddressEvent {
  final String id;
  const DeleteAddressEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ToggleDefaultAddressEvent extends AddressEvent {
  final String id;
  const ToggleDefaultAddressEvent(this.id);

  @override
  List<Object?> get props => [id];
}
