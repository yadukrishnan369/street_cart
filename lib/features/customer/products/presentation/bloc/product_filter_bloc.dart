import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_filter_event.dart';
import 'product_filter_state.dart';
export 'product_filter_state.dart';

// Product Filter Bloc
class ProductFilterBloc extends Bloc<ProductFilterEvent, ProductFilterState> {
  ProductFilterBloc()
    : super(
        ProductFilterState(
          allProducts: const [],
          selectedSort: 'Newest',
          absoluteMinPrice: 0,
          absoluteMaxPrice: 10000,
          minPrice: 0,
          maxPrice: 10000,
          selectedCategories: const {'All'},
          categoryQuery: '',
          showAllCategories: false,
          availableColors: const [],
          selectedColors: const {},
          availableSizes: const [],
          selectedSizes: const {},
        ),
      ) {
    on<InitProductFilter>(_onInitProductFilter);
    on<UpdateFilterSort>(_onUpdateFilterSort);
    on<UpdateFilterPriceRange>(_onUpdateFilterPriceRange);
    on<ToggleFilterCategory>(_onToggleFilterCategory);
    on<UpdateFilterCategoryQuery>(_onUpdateFilterCategoryQuery);
    on<ToggleFilterShowAllCategories>(_onToggleShowAllCategories);
    on<ToggleFilterColor>(_onToggleFilterColor);
    on<ToggleFilterSize>(_onToggleFilterSize);
    on<ToggleFilterRating>(_onToggleFilterRating);
    on<ResetProductFilter>(_onResetProductFilter);
  }

  // Initializes Filter State
  void _onInitProductFilter(
    InitProductFilter event,
    Emitter<ProductFilterState> emit,
  ) {
    final base = ProductFilterState(
      allProducts: event.allProducts,
      selectedSort: event.selectedSort,
      absoluteMinPrice: 0,
      absoluteMaxPrice: 10000,
      minPrice: event.initialRange.start,
      maxPrice: event.initialRange.end,
      selectedCategories: event.selectedCategories.isEmpty
          ? {'All'}
          : event.selectedCategories,
      categoryQuery: '',
      showAllCategories: false,
      availableColors: const [],
      selectedColors: event.selectedColors,
      availableSizes: const [],
      selectedSizes: event.selectedSizes,
      selectedRating: event.selectedRating,
    );
    emit(_withComputedPriceAndVariants(base));
  }

  // Get Min/Max Price From Available Products
  ProductFilterState _withComputedPriceAndVariants(ProductFilterState s) {
    if (s.allProducts.isEmpty) {
      return s.copyWith(
        absoluteMinPrice: 0,
        absoluteMaxPrice: 10000,
        minPrice: s.minPrice.clamp(0, 10000),
        maxPrice: s.maxPrice.clamp(0, 10000),
      );
    }

    double minVal = double.infinity;
    double maxVal = -double.infinity;
    for (final p in s.allProducts) {
      final price = p.offerPrice ?? p.originalPrice;
      if (price < minVal) minVal = price;
      if (price > maxVal) maxVal = price;
    }
    if (minVal == double.infinity) minVal = 0;
    if (maxVal == -double.infinity) maxVal = 10000;

    if (minVal == maxVal) minVal = 0;

    double finalMin = s.minPrice;
    double finalMax = s.maxPrice;

    if (finalMin == 0 && finalMax == 10000) {
      finalMin = minVal;
      finalMax = maxVal;
    } else {
      finalMin = finalMin.clamp(minVal, maxVal);
      finalMax = finalMax.clamp(minVal, maxVal);
    }

    final colors = _computeAvailableColors(s);

    return s.copyWith(
      absoluteMinPrice: minVal,
      absoluteMaxPrice: maxVal,
      minPrice: finalMin,
      maxPrice: finalMax,
      availableColors: colors,
      availableSizes: const [],
    );
  }

  // Get All Color From All Products
  List<String> _computeAvailableColors(ProductFilterState s) {
    final Set<String> colorsSet = {};
    for (final p in s.allProducts) {
      colorsSet.addAll(p.allColors);
    }
    return colorsSet.toList();
  }

  // Updates the Active Sort
  void _onUpdateFilterSort(
    UpdateFilterSort event,
    Emitter<ProductFilterState> emit,
  ) {
    emit(state.copyWith(selectedSort: event.sort));
  }

  // Applies New Price Range Values
  void _onUpdateFilterPriceRange(
    UpdateFilterPriceRange event,
    Emitter<ProductFilterState> emit,
  ) {
    emit(
      state.copyWith(
        minPrice: event.start.clamp(
          state.absoluteMinPrice,
          state.absoluteMaxPrice,
        ),
        maxPrice: event.end.clamp(
          state.absoluteMinPrice,
          state.absoluteMaxPrice,
        ),
      ),
    );
  }

  // Toggles Category and Refresh colors and sizes
  void _onToggleFilterCategory(
    ToggleFilterCategory event,
    Emitter<ProductFilterState> emit,
  ) {
    final Set<String> updated = Set<String>.from(state.selectedCategories);
    final cat = event.category;

    if (cat == 'All') {
      updated
        ..clear()
        ..add('All');
    } else {
      updated.remove('All');
      if (updated.contains(cat)) {
        updated.remove(cat);
        if (updated.isEmpty) updated.add('All');
      } else {
        updated.add(cat);
      }
    }

    final colors = _computeAvailableColors(
      state.copyWith(selectedCategories: updated),
    );
    final Set<String> nextColors = Set<String>.from(state.selectedColors)
      ..retainAll(colors);
    final Set<String> nextSizes = Set<String>.from(state.selectedSizes)
      ..retainAll(const []);

    emit(
      state.copyWith(
        selectedCategories: updated,
        availableColors: colors,
        selectedColors: nextColors,
        availableSizes: const [],
        selectedSizes: nextSizes,
      ),
    );
  }

  // Updates the Category By Search
  void _onUpdateFilterCategoryQuery(
    UpdateFilterCategoryQuery event,
    Emitter<ProductFilterState> emit,
  ) {
    emit(state.copyWith(categoryQuery: event.query));
  }

  // Show All Category
  void _onToggleShowAllCategories(
    ToggleFilterShowAllCategories event,
    Emitter<ProductFilterState> emit,
  ) {
    emit(state.copyWith(showAllCategories: event.show));
  }

  // Toggles Color and Refresh sizes
  void _onToggleFilterColor(
    ToggleFilterColor event,
    Emitter<ProductFilterState> emit,
  ) {
    final Set<String> updated = Set<String>.from(state.selectedColors);
    if (updated.contains(event.color)) {
      updated.remove(event.color);
    } else {
      updated.add(event.color);
    }

    final Set<String> nextSizes = Set<String>.from(state.selectedSizes)
      ..retainAll(const []);

    emit(
      state.copyWith(
        selectedColors: updated,
        availableSizes: const [],
        selectedSizes: nextSizes,
      ),
    );
  }

  // Toggles Size Chip in the Selected Sizes
  void _onToggleFilterSize(
    ToggleFilterSize event,
    Emitter<ProductFilterState> emit,
  ) {
    final Set<String> updated = Set<String>.from(state.selectedSizes);
    if (updated.contains(event.size)) {
      updated.remove(event.size);
    } else {
      updated.add(event.size);
    }
    emit(state.copyWith(selectedSizes: updated));
  }

  // Toggles Rating Chip
  void _onToggleFilterRating(
    ToggleFilterRating event,
    Emitter<ProductFilterState> emit,
  ) {
    emit(
      state.copyWith(
        selectedRating: state.selectedRating == event.rating
            ? null
            : event.rating,
      ),
    );
  }

  // Resets All Filter Values Back to Default
  void _onResetProductFilter(
    ResetProductFilter event,
    Emitter<ProductFilterState> emit,
  ) {
    final colors = _computeAvailableColors(state);

    emit(
      state.copyWith(
        selectedSort: 'Newest',
        minPrice: state.absoluteMinPrice,
        maxPrice: state.absoluteMaxPrice,
        selectedCategories: {'All'},
        categoryQuery: '',
        showAllCategories: false,
        selectedColors: const {},
        availableColors: colors,
        selectedSizes: const {},
        availableSizes: const [],
        selectedRating: null,
      ),
    );
  }
}
