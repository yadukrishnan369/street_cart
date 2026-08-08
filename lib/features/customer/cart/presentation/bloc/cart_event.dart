import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddProductToCart extends CartEvent {
  final ProductModel product;
  final String? selectedColor;
  final String? selectedSize;

  const AddProductToCart({
    required this.product,
    this.selectedColor,
    this.selectedSize,
  });

  @override
  List<Object?> get props => [product, selectedColor, selectedSize];
}

class UpdateItemQuantity extends CartEvent {
  final String itemId;
  final int quantity;

  const UpdateItemQuantity({required this.itemId, required this.quantity});

  @override
  List<Object?> get props => [itemId, quantity];
}

class RemoveItem extends CartEvent {
  final String itemId;

  const RemoveItem({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class ClearAllCart extends CartEvent {}

class ValidateCartForCheckout extends CartEvent {}

class RefreshCartAvailability extends CartEvent {}

class ClearLocalCart extends CartEvent {}

class ToggleSummaryVisibility extends CartEvent {
  final bool isVisible;

  const ToggleSummaryVisibility({required this.isVisible});

  @override
  List<Object?> get props => [isVisible];
}
