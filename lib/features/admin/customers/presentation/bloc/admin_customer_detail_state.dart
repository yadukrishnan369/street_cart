import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';

abstract class AdminCustomerDetailState {}

// Initial State
class AdminCustomerDetailInitial extends AdminCustomerDetailState {}

// Loading state
class AdminCustomerDetailLoading extends AdminCustomerDetailState {}

// Action in progress State
class AdminCustomerDetailActionInProgress extends AdminCustomerDetailState {}

// Admin Customer Detail Loaded State
class AdminCustomerDetailLoaded extends AdminCustomerDetailState {
  final CustomerModel customer;
  final List<AddressModel> addresses;
  final List<OrderModel> orders;
  final int currentPage;

  AdminCustomerDetailLoaded({
    required this.customer,
    required this.addresses,
    required this.orders,
    this.currentPage = 1,
  });

  AdminCustomerDetailLoaded copyWith({
    CustomerModel? customer,
    List<AddressModel>? addresses,
    List<OrderModel>? orders,
    int? currentPage,
  }) {
    return AdminCustomerDetailLoaded(
      customer: customer ?? this.customer,
      addresses: addresses ?? this.addresses,
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// Admin Customer Detail Error State
class AdminCustomerDetailError extends AdminCustomerDetailState {
  final String message;

  AdminCustomerDetailError(this.message);
}

// Admin Customer Detail Action Success State
class AdminCustomerDetailActionSuccess extends AdminCustomerDetailState {
  final String message;

  AdminCustomerDetailActionSuccess(this.message);
}
