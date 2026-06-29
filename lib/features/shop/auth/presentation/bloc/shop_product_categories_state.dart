part of 'shop_product_categories_cubit.dart';

abstract class ShopProductCategoriesState extends Equatable {
  const ShopProductCategoriesState();

  @override
  List<Object?> get props => [];
}

class ShopProductCategoriesInitial extends ShopProductCategoriesState {}

class ShopProductCategoriesLoading extends ShopProductCategoriesState {}

class ShopProductCategoriesLoaded extends ShopProductCategoriesState {
  final List<String> categories;

  const ShopProductCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class ShopProductCategoriesError extends ShopProductCategoriesState {
  final String message;

  const ShopProductCategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}
