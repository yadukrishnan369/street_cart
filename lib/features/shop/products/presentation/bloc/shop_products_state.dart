import 'package:equatable/equatable.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class ShopProductsState extends Equatable {
  const ShopProductsState();

  @override
  List<Object?> get props => [];
}

class ShopProductsInitial extends ShopProductsState {}

class ShopProductsLoading extends ShopProductsState {}

class ShopProductsLoaded extends ShopProductsState {
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final String searchQuery;
  final List<String> selectedCategories;
  final Map<String, dynamic> customConfig;

  const ShopProductsLoaded({
    required this.allProducts,
    required this.filteredProducts,
    this.searchQuery = '',
    this.selectedCategories = const ['All'],
    this.customConfig = const {},
  });

  ShopProductsLoaded copyWith({
    List<ProductModel>? allProducts,
    List<ProductModel>? filteredProducts,
    String? searchQuery,
    List<String>? selectedCategories,
    Map<String, dynamic>? customConfig,
  }) {
    return ShopProductsLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      customConfig: customConfig ?? this.customConfig,
    );
  }

  @override
  List<Object?> get props => [
    allProducts,
    filteredProducts,
    searchQuery,
    selectedCategories,
    customConfig,
  ];
}

class ShopProductsOperationSuccess extends ShopProductsState {
  final String message;
  const ShopProductsOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ShopProductsError extends ShopProductsState {
  final String error;
  const ShopProductsError(this.error);

  @override
  List<Object?> get props => [error];
}

class ShopProductCategoriesLoading extends ShopProductsState {}

class ShopProductCategoriesLoaded extends ShopProductsState {
  final List<String> categories;

  const ShopProductCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class ShopProductCategoriesError extends ShopProductsState {
  final String message;

  const ShopProductCategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}
