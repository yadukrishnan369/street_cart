import 'package:flutter/material.dart';

abstract class CustomerProductsEvent {}

class FetchCustomerProducts extends CustomerProductsEvent {
  final String? initialSearchQuery;
  final String? initialSelectedSort;
  final RangeValues? initialPriceRange;
  final Set<String>? initialSelectedCategories;
  final String? initialSelectedRating;

  FetchCustomerProducts({
    this.initialSearchQuery,
    this.initialSelectedSort,
    this.initialPriceRange,
    this.initialSelectedCategories,
    this.initialSelectedRating,
  });
}

class UpdateFilters extends CustomerProductsEvent {
  final String searchQuery;
  final Set<String> selectedCategories;
  final String selectedSort;
  final RangeValues priceRange;
  final String? selectedRating;

  UpdateFilters({
    required this.searchQuery,
    required this.selectedCategories,
    required this.selectedSort,
    required this.priceRange,
    this.selectedRating,
  });
}
