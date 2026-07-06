import 'package:flutter/material.dart';

abstract class CustomerProductsEvent {}

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
