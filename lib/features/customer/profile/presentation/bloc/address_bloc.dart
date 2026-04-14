import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/get_addresses.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/add_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/update_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/delete_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/set_default_address.dart';
import 'address_event.dart';
import 'address_state.dart';

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
  })  : _getAddresses = getAddresses,
        _addAddress = addAddress,
        _updateAddress = updateAddress,
        _deleteAddress = deleteAddress,
        _setDefaultAddress = setDefaultAddress,
        super(AddressInitial()) {
    on<FetchAddresses>(_onFetchAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<ToggleDefaultAddressEvent>(_onToggleDefaultAddress);
  }

  Future<void> _onFetchAddresses(
      FetchAddresses event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    try {
      final addresses = await _getAddresses();
      emit(AddressesLoaded(addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onAddAddress(
      AddAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressActionLoading());
    try {
      await _addAddress(event.address);
      emit(const AddressActionSuccess('Address added successfully'));
      add(FetchAddresses());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onUpdateAddress(
      UpdateAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressActionLoading());
    try {
      await _updateAddress(event.address.id, event.address);
      emit(const AddressActionSuccess('Address updated successfully'));
      add(FetchAddresses());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onDeleteAddress(
      DeleteAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddressActionLoading());
    try {
      await _deleteAddress(event.id);
      emit(const AddressActionSuccess('Address deleted successfully'));
      add(FetchAddresses());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onToggleDefaultAddress(
      ToggleDefaultAddressEvent event, Emitter<AddressState> emit) async {
    try {
      await _setDefaultAddress(event.id);
      add(FetchAddresses());
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}
