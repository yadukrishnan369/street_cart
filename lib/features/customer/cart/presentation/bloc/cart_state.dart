import 'package:equatable/equatable.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final bool isSummaryVisible;

  const CartLoaded({required this.items, this.isSummaryVisible = true});

  CartLoaded copyWith({List<CartItem>? items, bool? isSummaryVisible}) {
    return CartLoaded(
      items: items ?? this.items,
      isSummaryVisible: isSummaryVisible ?? this.isSummaryVisible,
    );
  }

  @override
  List<Object?> get props => [items, isSummaryVisible];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartItemUpdateError extends CartLoaded {
  final String errorMessage;
  final DateTime timestamp;

  CartItemUpdateError({
    required super.items,
    required this.errorMessage,
    super.isSummaryVisible = true,
  }) : timestamp = DateTime.now();

  @override
  List<Object?> get props => [items, isSummaryVisible, errorMessage, timestamp];
}
