import 'package:flutter/material.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';

abstract class CustomerProductsState {}

// Initial State
class CustomerProductsInitial extends CustomerProductsState {}

// Products Fetch in Loading
class CustomerProductsLoading extends CustomerProductsState {}

// Location Services Disabled State
class CustomerProductsLocationDisabled extends CustomerProductsState {}

// Products Successfully Loaded State
class CustomerProductsLoaded extends CustomerProductsState {
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final List<ShopProfileModel> shops;
  final String searchQuery;
  final Set<String> selectedCategories;
  final String selectedSort;
  final RangeValues priceRange;
  final String? selectedRating;
  final Set<String> selectedColors;
  final Set<String> selectedSizes;

  CustomerProductsLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required this.shops,
    required this.searchQuery,
    required this.selectedCategories,
    required this.selectedSort,
    required this.priceRange,
    this.selectedRating,
    this.selectedColors = const {},
    this.selectedSizes = const {},
  });
}

// Product Fetch Failed State
class CustomerProductsError extends CustomerProductsState {
  final String message;
  CustomerProductsError({required this.message});
}

// Product Detail Page State
class ProductDetailState extends CustomerProductsState {
  final String? selectedColor;
  final String? selectedSize;
  final String? variantWarningMessage;
  final int carouselIndex;
  final List<ReviewModel> reviews;

  ProductDetailState({
    this.selectedColor,
    this.selectedSize,
    this.variantWarningMessage,
    this.carouselIndex = 0,
    this.reviews = const [],
  });

  ProductDetailState copyWith({
    String? selectedColor,
    String? selectedSize,
    String? Function()? variantWarningMessage,
    int? carouselIndex,
    List<ReviewModel>? reviews,
  }) {
    return ProductDetailState(
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      variantWarningMessage: variantWarningMessage != null
          ? variantWarningMessage()
          : this.variantWarningMessage,
      carouselIndex: carouselIndex ?? this.carouselIndex,
      reviews: reviews ?? this.reviews,
    );
  }
}
