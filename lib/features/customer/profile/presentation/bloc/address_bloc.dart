import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/get_addresses.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/add_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/update_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/delete_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/set_default_address.dart';
import 'address_event.dart';
import 'address_state.dart';

// Address Bloc
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddresses _getAddresses;
  final AddAddress _addAddress;
  final UpdateAddress _updateAddress;
  final DeleteAddress _deleteAddress;
  final SetDefaultAddress _setDefaultAddress;

  AddressBloc({
    required GetAddresses getAddresses,
    required AddAddress addAddress,
    required UpdateAddress updateAddress,
    required DeleteAddress deleteAddress,
    required SetDefaultAddress setDefaultAddress,
  }) : _getAddresses = getAddresses,
       _addAddress = addAddress,
       _updateAddress = updateAddress,
       _deleteAddress = deleteAddress,
       _setDefaultAddress = setDefaultAddress,
       super(const AddressInitial()) {
    on<FetchAddresses>(_onFetchAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<ToggleDefaultAddressEvent>(_onToggleDefaultAddress);
    on<SelectAddressTypeEvent>(_onSelectAddressType);
  }

  // Fetch all saved addresses
  Future<void> _onFetchAddresses(
    FetchAddresses event,
    Emitter<AddressState> emit,
  ) async {
    if (state is! AddressesLoaded) {
      emit(AddressLoading(selectedType: state.selectedType));
    }
    try {
      final addresses = await _getAddresses();
      emit(AddressesLoaded(addresses, selectedType: state.selectedType));
    } catch (e) {
      emit(AddressError(e.toString(), selectedType: state.selectedType));
    }
  }

  // Add a new address
  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressActionLoading(selectedType: state.selectedType));
    try {
      await _addAddress(event.address);
      emit(
        AddressActionSuccess(
          'Address added successfully',
          selectedType: state.selectedType,
        ),
      );
      add(FetchAddresses());
    } catch (e) {
      emit(AddressError(e.toString(), selectedType: state.selectedType));
    }
  }

  // Update an existing saved address
  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressActionLoading(selectedType: state.selectedType));
    try {
      await _updateAddress(event.address.id, event.address);
      emit(
        AddressActionSuccess(
          'Address updated successfully',
          selectedType: state.selectedType,
        ),
      );
      add(FetchAddresses());
    } catch (e) {
      emit(AddressError(e.toString(), selectedType: state.selectedType));
    }
  }

  // Delete a saved address
  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressActionLoading(selectedType: state.selectedType));
    try {
      await _deleteAddress(event.id);
      emit(
        AddressActionSuccess(
          'Address deleted successfully',
          selectedType: state.selectedType,
        ),
      );
      add(FetchAddresses());
    } catch (e) {
      emit(AddressError(e.toString(), selectedType: state.selectedType));
    }
  }

  // Set selected address as default
  Future<void> _onToggleDefaultAddress(
    ToggleDefaultAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    try {
      await _setDefaultAddress(event.id);
      add(FetchAddresses());
    } catch (e) {
      emit(AddressError(e.toString(), selectedType: state.selectedType));
    }
  }

  // Address type selection - HOME, WORK, OTHER
  void _onSelectAddressType(
    SelectAddressTypeEvent event,
    Emitter<AddressState> emit,
  ) {
    if (state is AddressInitial) {
      emit(AddressInitial(selectedType: event.type));
    } else if (state is AddressLoading) {
      emit(AddressLoading(selectedType: event.type));
    } else if (state is AddressActionLoading) {
      emit(AddressActionLoading(selectedType: event.type));
    } else if (state is AddressesLoaded) {
      emit(
        AddressesLoaded(
          (state as AddressesLoaded).addresses,
          selectedType: event.type,
        ),
      );
    } else if (state is AddressActionSuccess) {
      emit(
        AddressActionSuccess(
          (state as AddressActionSuccess).message,
          selectedType: event.type,
        ),
      );
    } else if (state is AddressError) {
      emit(
        AddressError((state as AddressError).message, selectedType: event.type),
      );
    }
  }
}
