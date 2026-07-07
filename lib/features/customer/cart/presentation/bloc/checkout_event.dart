import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class LoadCheckout extends CheckoutEvent {
  final List<CartItem> cartItems;

  const LoadCheckout(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class SelectPaymentMethod extends CheckoutEvent {
  final String method;

  const SelectPaymentMethod(this.method);

  @override
  List<Object?> get props => [method];
}
