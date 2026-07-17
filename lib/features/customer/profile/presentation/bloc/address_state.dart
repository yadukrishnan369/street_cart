import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

abstract class AddressState extends Equatable {
  final String selectedType;
  const AddressState({this.selectedType = 'HOME'});

  @override
  List<Object?> get props => [selectedType];
}

// Initial address state
class AddressInitial extends AddressState {
  const AddressInitial({super.selectedType});
}

// Addresses list loading state
class AddressLoading extends AddressState {
  const AddressLoading({super.selectedType});
}

// Address modification in progress
class AddressActionLoading extends AddressState {
  const AddressActionLoading({super.selectedType});
}

// Addresses list loaded State
class AddressesLoaded extends AddressState {
  final List<AddressModel> addresses;
  const AddressesLoaded(this.addresses, {super.selectedType});

  @override
  List<Object?> get props => [addresses, selectedType];
}

// Address modification success state
class AddressActionSuccess extends AddressState {
  final String message;
  const AddressActionSuccess(this.message, {super.selectedType});

  @override
  List<Object?> get props => [message, selectedType];
}

// Error state
class AddressError extends AddressState {
  final String message;
  const AddressError(this.message, {super.selectedType});

  @override
  List<Object?> get props => [message, selectedType];
}
