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

  final Set<String> unavailableItemIds;

  final Set<String> unviewableItemIds;

  const CartLoaded({
    required this.items,
    this.isSummaryVisible = true,
    this.unavailableItemIds = const {},
    this.unviewableItemIds = const {},
  });

  CartLoaded copyWith({
    List<CartItem>? items,
    bool? isSummaryVisible,
    Set<String>? unavailableItemIds,
    Set<String>? unviewableItemIds,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      isSummaryVisible: isSummaryVisible ?? this.isSummaryVisible,
      unavailableItemIds: unavailableItemIds ?? this.unavailableItemIds,
      unviewableItemIds: unviewableItemIds ?? this.unviewableItemIds,
    );
  }

  @override
  List<Object?> get props => [
    items,
    isSummaryVisible,
    unavailableItemIds,
    unviewableItemIds,
  ];
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
    super.unavailableItemIds = const {},
    super.unviewableItemIds = const {},
  }) : timestamp = DateTime.now();

  @override
  List<Object?> get props => [
    items,
    isSummaryVisible,
    unavailableItemIds,
    unviewableItemIds,
    errorMessage,
    timestamp,
  ];
}

class CartCheckoutValidating extends CartLoaded {
  const CartCheckoutValidating({
    required super.items,
    super.isSummaryVisible,
    super.unavailableItemIds,
    super.unviewableItemIds,
  });

  @override
  List<Object?> get props => [...super.props, 'validating'];
}

class CartCheckoutReady extends CartLoaded {
  const CartCheckoutReady({
    required super.items,
    super.isSummaryVisible,
    super.unavailableItemIds,
    super.unviewableItemIds,
  });

  @override
  List<Object?> get props => [...super.props, 'ready'];
}

class CartCheckoutInvalid extends CartLoaded {
  final List<String> reasons;

  const CartCheckoutInvalid({
    required super.items,
    required this.reasons,
    required super.unavailableItemIds,
    required super.unviewableItemIds,
    super.isSummaryVisible,
  });

  @override
  List<Object?> get props => [...super.props, reasons];
}
