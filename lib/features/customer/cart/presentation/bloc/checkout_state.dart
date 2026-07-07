import 'package:equatable/equatable.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final List<String> allowedPaymentMethods;
  final String selectedPaymentMethod;

  const CheckoutLoaded({
    required this.allowedPaymentMethods,
    required this.selectedPaymentMethod,
  });

  CheckoutLoaded copyWith({
    List<String>? allowedPaymentMethods,
    String? selectedPaymentMethod,
  }) {
    return CheckoutLoaded(
      allowedPaymentMethods:
          allowedPaymentMethods ?? this.allowedPaymentMethods,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }

  @override
  List<Object?> get props => [allowedPaymentMethods, selectedPaymentMethod];
}

class CheckoutError extends CheckoutState {
  final String message;

  const CheckoutError(this.message);

  @override
  List<Object?> get props => [message];
}
