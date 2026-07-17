import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

//  Fetch Address Event
class FetchAddresses extends AddressEvent {}

// Add Address Event
class AddAddressEvent extends AddressEvent {
  final AddressModel address;
  const AddAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

// Update Address Event
class UpdateAddressEvent extends AddressEvent {
  final AddressModel address;
  const UpdateAddressEvent(this.address);

  @override
  List<Object?> get props => [address];
}

// Delete Address Event
class DeleteAddressEvent extends AddressEvent {
  final String id;
  const DeleteAddressEvent(this.id);

  @override
  List<Object?> get props => [id];
}

// Defulat Address Event
class ToggleDefaultAddressEvent extends AddressEvent {
  final String id;
  const ToggleDefaultAddressEvent(this.id);

  @override
  List<Object?> get props => [id];
}

// Selected Address type Event
class SelectAddressTypeEvent extends AddressEvent {
  final String type;
  const SelectAddressTypeEvent(this.type);

  @override
  List<Object?> get props => [type];
}
