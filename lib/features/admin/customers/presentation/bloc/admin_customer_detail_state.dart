import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import '../../data/models/customer_model.dart';

abstract class AdminCustomerDetailState {}

class AdminCustomerDetailInitial extends AdminCustomerDetailState {}

class AdminCustomerDetailLoading extends AdminCustomerDetailState {}

class AdminCustomerDetailActionInProgress extends AdminCustomerDetailState {}

class AdminCustomerDetailLoaded extends AdminCustomerDetailState {
  final CustomerModel customer;
  final List<AddressModel> addresses;

  AdminCustomerDetailLoaded({
    required this.customer,
    required this.addresses,
  });
}

class AdminCustomerDetailError extends AdminCustomerDetailState {
  final String message;

  AdminCustomerDetailError(this.message);
}

class AdminCustomerDetailActionSuccess extends AdminCustomerDetailState {
  final String message;

  AdminCustomerDetailActionSuccess(this.message);
}
