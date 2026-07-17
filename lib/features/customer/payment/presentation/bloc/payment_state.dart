import 'package:equatable/equatable.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentProcessing extends PaymentState {}

class PaymentOrderCreating extends PaymentState {
  final String paymentMethod;

  const PaymentOrderCreating(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class PaymentSuccess extends PaymentState {
  final String paymentMethod;
  final String paymentStatus;
  final String orderId;

  const PaymentSuccess({
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderId,
  });

  @override
  List<Object?> get props => [paymentMethod, paymentStatus, orderId];
}

class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentOverlayPhase extends PaymentState {
  final bool isLoading;
  final int phase;

  const PaymentOverlayPhase({required this.isLoading, required this.phase});

  @override
  List<Object?> get props => [isLoading, phase];
}
