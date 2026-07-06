import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'product_filter_state.dart';
export 'product_filter_state.dart';

class ProductFilterCubit extends Cubit<ProductFilterState> {
  ProductFilterCubit({
    required List<ProductModel> allProducts,
    required String selectedSort,
    required RangeValues initialRange,
    required Set<String> selectedCategories,
    required String? selectedRating,
    required Set<String> selectedColors,
    required Set<String> selectedSizes,
  }) : super(
         ProductFilterState(
           allProducts: allProducts,
           selectedSort: selectedSort,
           absoluteMinPrice: 0,
           absoluteMaxPrice: 10000,
           minPrice: initialRange.start,
           maxPrice: initialRange.end,
           selectedCategories: selectedCategories.isEmpty
               ? {'All'}
               : selectedCategories,
           categoryQuery: '',
           showAllCategories: false,
           availableColors: const [],
           selectedColors: selectedColors,
           availableSizes: const [],
           selectedSizes: selectedSizes,
           selectedRating: selectedRating,
         ),
       ) {
    _initializePricesAndVariants();
  }

  void _initializePricesAndVariants() {
    if (state.allProducts.isEmpty) {
      emit(
        state.copyWith(
          absoluteMinPrice: 0,
          absoluteMaxPrice: 10000,
          minPrice: state.minPrice.clamp(0, 10000),
          maxPrice: state.maxPrice.clamp(0, 10000),
        ),
      );
      return;
    }

    double minVal = double.infinity;
    double maxVal = -double.infinity;

    for (final p in state.allProducts) {
      final price = p.offerPrice ?? p.originalPrice;
      if (price < minVal) minVal = price;
      if (price > maxVal) maxVal = price;
    }

    if (minVal == double.infinity) minVal = 0;
    if (maxVal == -double.infinity) maxVal = 10000;

    // Handle single price product case
    if (minVal == maxVal) {
      minVal = 0;
    }

    // Retain initial range clamp
    double finalMin = state.minPrice;
    double finalMax = state.maxPrice;

    // Reset range bounds to matching product bounds
    if (finalMin == 0 && finalMax == 10000) {
      finalMin = minVal;
      finalMax = maxVal;
    } else {
      finalMin = finalMin.clamp(minVal, maxVal);
      finalMax = finalMax.clamp(minVal, maxVal);
    }

    // Refresh colors and sizes
    final colors = _computeFilteredColors(state.selectedCategories);
    final sizes = _computeFilteredSizes(
      state.selectedCategories,
      state.selectedColors,
    );

    emit(
      state.copyWith(
        absoluteMinPrice: minVal,
        absoluteMaxPrice: maxVal,
        minPrice: finalMin,
        maxPrice: finalMax,
        availableColors: colors,
        availableSizes: sizes,
      ),
    );
  }

  // show all available product colors
  List<String> _computeFilteredColors(Set<String> selectedCats) {
    final Set<String> colorsSet = {};
    for (final p in state.allProducts) {
      colorsSet.addAll(p.allColors);
    }
    return colorsSet.toList();
  }

  List<String> _computeFilteredSizes(
    Set<String> selectedCats,
    Set<String> selColors,
  ) {
    return const [];
  }

  // Sort change action
  void updateSort(String sort) => emit(state.copyWith(selectedSort: sort));

  // Slider change action
  void updatePriceRange(double start, double end) {
    emit(
      state.copyWith(
        minPrice: start.clamp(state.absoluteMinPrice, state.absoluteMaxPrice),
        maxPrice: end.clamp(state.absoluteMinPrice, state.absoluteMaxPrice),
      ),
    );
  }

  // Category toggle selection
  void toggleCategory(String cat) {
    final Set<String> updated = Set<String>.from(state.selectedCategories);
    if (cat == 'All') {
      updated.clear();
      updated.add('All');
    } else {
      updated.remove('All');
      if (updated.contains(cat)) {
        updated.remove(cat);
        if (updated.isEmpty) {
          updated.add('All');
        }
      } else {
        updated.add(cat);
      }
    }

    // When categories change, we refresh available colors & sizes
    final colors = _computeFilteredColors(updated);
    final Set<String> nextSelectedColors = Set<String>.from(
      state.selectedColors,
    )..retainAll(colors);

    final sizes = _computeFilteredSizes(updated, nextSelectedColors);
    final Set<String> nextSelectedSizes = Set<String>.from(state.selectedSizes)
      ..retainAll(sizes);

    emit(
      state.copyWith(
        selectedCategories: updated,
        availableColors: colors,
        selectedColors: nextSelectedColors,
        availableSizes: sizes,
        selectedSizes: nextSelectedSizes,
      ),
    );
  }

  void updateCategoryQuery(String query) =>
      emit(state.copyWith(categoryQuery: query));

  void toggleShowAllCategories(bool show) =>
      emit(state.copyWith(showAllCategories: show));

  // Color selection action
  void toggleColor(String color) {
    final Set<String> updated = Set<String>.from(state.selectedColors);
    if (updated.contains(color)) {
      updated.remove(color);
    } else {
      updated.add(color);
    }

    // Refresh sizes based on updated colors
    final sizes = _computeFilteredSizes(state.selectedCategories, updated);
    final Set<String> nextSelectedSizes = Set<String>.from(state.selectedSizes)
      ..retainAll(sizes);

    emit(
      state.copyWith(
        selectedColors: updated,
        availableSizes: sizes,
        selectedSizes: nextSelectedSizes,
      ),
    );
  }

  // Size selection action
  void toggleSize(String size) {
    final Set<String> updated = Set<String>.from(state.selectedSizes);
    if (updated.contains(size)) {
      updated.remove(size);
    } else {
      updated.add(size);
    }
    emit(state.copyWith(selectedSizes: updated));
  }

  // Rating selection placeholder
  void toggleRating(String rating) {
    emit(
      state.copyWith(
        selectedRating: state.selectedRating == rating ? null : rating,
      ),
    );
  }

  // Reset all values back to default configurations
  void reset() {
    final Set<String> defaultCats = {'All'};
    final colors = _computeFilteredColors(defaultCats);
    final sizes = _computeFilteredSizes(defaultCats, const {});

    emit(
      state.copyWith(
        selectedSort: 'Newest',
        minPrice: state.absoluteMinPrice,
        maxPrice: state.absoluteMaxPrice,
        selectedCategories: defaultCats,
        categoryQuery: '',
        showAllCategories: false,
        selectedColors: const {},
        availableColors: colors,
        selectedSizes: const {},
        availableSizes: sizes,
        selectedRating: null,
      ),
    );
  }
}
