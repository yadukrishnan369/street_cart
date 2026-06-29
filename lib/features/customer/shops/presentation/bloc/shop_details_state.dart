import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class ShopDetailsState extends Equatable {
  const ShopDetailsState();

  @override
  List<Object?> get props => [];
}

class ShopDetailsInitial extends ShopDetailsState {}

class ShopDetailsLoading extends ShopDetailsState {}

class ShopDetailsLoaded extends ShopDetailsState {
  final List<ProductModel> products;

  const ShopDetailsLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class ShopDetailsError extends ShopDetailsState {
  final String message;

  const ShopDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
