import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class ShopDetailsState extends Equatable {
  const ShopDetailsState();

  @override
  List<Object?> get props => [];
}

// Shop Intital State
class ShopDetailsInitial extends ShopDetailsState {}

// Shop Loading State
class ShopDetailsLoading extends ShopDetailsState {}

// Shop Loaded State
class ShopDetailsLoaded extends ShopDetailsState {
  final List<ProductModel> products;

  const ShopDetailsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

// Shop Error State
class ShopDetailsError extends ShopDetailsState {
  final String message;

  const ShopDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
