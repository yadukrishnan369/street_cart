part of 'shop_categories_cubit.dart';

abstract class ShopCategoriesState extends Equatable {
  const ShopCategoriesState();

  @override
  List<Object?> get props => [];
}

class ShopCategoriesInitial extends ShopCategoriesState {}

class ShopCategoriesLoading extends ShopCategoriesState {}

class ShopCategoriesLoaded extends ShopCategoriesState {
  final List<String> categories;

  const ShopCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class ShopCategoriesError extends ShopCategoriesState {
  final String message;

  const ShopCategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}
