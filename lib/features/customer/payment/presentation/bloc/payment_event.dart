import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitiateRazorpayPayment extends PaymentEvent {
  final List<CartItem> items;
  final AddressModel address;
  final double totalAmount;
  final String contact;

  const InitiateRazorpayPayment({
    required this.items,
    required this.address,
    required this.totalAmount,
    required this.contact,
  });

  @override
  List<Object?> get props => [items, address, totalAmount, contact];
}

class CompleteOrderWithCOD extends PaymentEvent {
  final List<CartItem> items;
  final AddressModel address;
  final double totalAmount;

  const CompleteOrderWithCOD({
    required this.items,
    required this.address,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [items, address, totalAmount];
}

class PaymentCompletedInternal extends PaymentEvent {
  final String paymentMethod;
  final String paymentStatus;
  final String? orderId;
  final String? errorMessage;

  const PaymentCompletedInternal({
    required this.paymentMethod,
    required this.paymentStatus,
    this.orderId,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    paymentMethod,
    paymentStatus,
    orderId,
    errorMessage,
  ];
}

class ProcessPaymentPlacement extends PaymentEvent {
  final String paymentMethod;
  final String paymentStatus;

  const ProcessPaymentPlacement({
    required this.paymentMethod,
    required this.paymentStatus,
  });

  @override
  List<Object?> get props => [paymentMethod, paymentStatus];
}
