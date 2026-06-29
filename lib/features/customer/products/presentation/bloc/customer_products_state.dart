import 'package:flutter/material.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class CustomerProductsState {}

class CustomerProductsInitial extends CustomerProductsState {}

class CustomerProductsLoading extends CustomerProductsState {}

class CustomerProductsLocationDisabled extends CustomerProductsState {}

class CustomerProductsLoaded extends CustomerProductsState {
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final List<ShopProfileModel> shops;
  final String searchQuery;
  final Set<String> selectedCategories;
  final String selectedSort;
  final RangeValues priceRange;
  final String? selectedRating;

  CustomerProductsLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required this.shops,
    required this.searchQuery,
    required this.selectedCategories,
    required this.selectedSort,
    required this.priceRange,
    this.selectedRating,
  });
}

class CustomerProductsError extends CustomerProductsState {
  final String message;

  CustomerProductsError({required this.message});
}
