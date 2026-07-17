import 'package:flutter/material.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

abstract class ProductFilterEvent {}

// When Filter Page Opens Initialize All Values
class InitProductFilter extends ProductFilterEvent {
  final List<ProductModel> allProducts;
  final String selectedSort;
  final RangeValues initialRange;
  final Set<String> selectedCategories;
  final String? selectedRating;
  final Set<String> selectedColors;
  final Set<String> selectedSizes;

  InitProductFilter({
    required this.allProducts,
    required this.selectedSort,
    required this.initialRange,
    required this.selectedCategories,
    this.selectedRating,
    required this.selectedColors,
    required this.selectedSizes,
  });
}

class UpdateFilterSort extends ProductFilterEvent {
  final String sort;
  UpdateFilterSort(this.sort);
}

class UpdateFilterPriceRange extends ProductFilterEvent {
  final double start;
  final double end;
  UpdateFilterPriceRange(this.start, this.end);
}

class ToggleFilterCategory extends ProductFilterEvent {
  final String category;
  ToggleFilterCategory(this.category);
}

class UpdateFilterCategoryQuery extends ProductFilterEvent {
  final String query;
  UpdateFilterCategoryQuery(this.query);
}

class ToggleFilterShowAllCategories extends ProductFilterEvent {
  final bool show;
  ToggleFilterShowAllCategories(this.show);
}

class ToggleFilterColor extends ProductFilterEvent {
  final String color;
  ToggleFilterColor(this.color);
}

class ToggleFilterSize extends ProductFilterEvent {
  final String size;
  ToggleFilterSize(this.size);
}

class ToggleFilterRating extends ProductFilterEvent {
  final String rating;
  ToggleFilterRating(this.rating);
}

class ResetProductFilter extends ProductFilterEvent {}
