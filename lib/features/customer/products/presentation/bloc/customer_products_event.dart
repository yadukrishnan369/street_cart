import 'package:flutter/material.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class CustomerProductsEvent {}

// Fetch All Nearby Products and Shops
class FetchCustomerProducts extends CustomerProductsEvent {
  final String? initialSearchQuery;
  final String? initialSelectedSort;
  final RangeValues? initialPriceRange;
  final Set<String>? initialSelectedCategories;
  final String? initialSelectedRating;
  final Set<String>? initialSelectedColors;
  final Set<String>? initialSelectedSizes;

  FetchCustomerProducts({
    this.initialSearchQuery,
    this.initialSelectedSort,
    this.initialPriceRange,
    this.initialSelectedCategories,
    this.initialSelectedRating,
    this.initialSelectedColors,
    this.initialSelectedSizes,
  });
}

// New Filter/Sort/Search Values to the Loaded Product List
class UpdateFilters extends CustomerProductsEvent {
  final String searchQuery;
  final Set<String> selectedCategories;
  final String selectedSort;
  final RangeValues priceRange;
  final String? selectedRating;
  final Set<String> selectedColors;
  final Set<String> selectedSizes;

  UpdateFilters({
    required this.searchQuery,
    required this.selectedCategories,
    required this.selectedSort,
    required this.priceRange,
    this.selectedRating,
    required this.selectedColors,
    required this.selectedSizes,
  });
}

// Initializes Product Detail
class InitProductDetail extends CustomerProductsEvent {
  final ProductModel product;
  final String? initialColor;
  final String? initialSize;

  InitProductDetail({
    required this.product,
    this.initialColor,
    this.initialSize,
  });
}

class SelectProductColor extends CustomerProductsEvent {
  final String color;
  final ProductModel product;

  SelectProductColor({required this.color, required this.product});
}

class SelectProductSize extends CustomerProductsEvent {
  final String size;
  SelectProductSize(this.size);
}

class UpdateCarouselIndex extends CustomerProductsEvent {
  final int index;
  UpdateCarouselIndex(this.index);
}
