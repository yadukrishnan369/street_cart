import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class ProductFilterState {
  final List<ProductModel> allProducts;
  final String selectedSort;

  // Price Range
  final double absoluteMinPrice;
  final double absoluteMaxPrice;
  final double minPrice;
  final double maxPrice;

  // Categories
  final Set<String> selectedCategories;
  final String categoryQuery;
  final bool showAllCategories;

  // Colors
  final List<String> availableColors;
  final Set<String> selectedColors;

  // Sizes
  final List<String> availableSizes;
  final Set<String> selectedSizes;

  // Ratings
  final String? selectedRating;

  ProductFilterState({
    required this.allProducts,
    required this.selectedSort,
    required this.absoluteMinPrice,
    required this.absoluteMaxPrice,
    required this.minPrice,
    required this.maxPrice,
    required this.selectedCategories,
    required this.categoryQuery,
    required this.showAllCategories,
    required this.availableColors,
    required this.selectedColors,
    required this.availableSizes,
    required this.selectedSizes,
    this.selectedRating,
  });

  ProductFilterState copyWith({
    List<ProductModel>? allProducts,
    String? selectedSort,
    double? absoluteMinPrice,
    double? absoluteMaxPrice,
    double? minPrice,
    double? maxPrice,
    Set<String>? selectedCategories,
    String? categoryQuery,
    bool? showAllCategories,
    List<String>? availableColors,
    Set<String>? selectedColors,
    List<String>? availableSizes,
    Set<String>? selectedSizes,
    String? selectedRating,
  }) {
    return ProductFilterState(
      allProducts: allProducts ?? this.allProducts,
      selectedSort: selectedSort ?? this.selectedSort,
      absoluteMinPrice: absoluteMinPrice ?? this.absoluteMinPrice,
      absoluteMaxPrice: absoluteMaxPrice ?? this.absoluteMaxPrice,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      categoryQuery: categoryQuery ?? this.categoryQuery,
      showAllCategories: showAllCategories ?? this.showAllCategories,
      availableColors: availableColors ?? this.availableColors,
      selectedColors: selectedColors ?? this.selectedColors,
      availableSizes: availableSizes ?? this.availableSizes,
      selectedSizes: selectedSizes ?? this.selectedSizes,
      selectedRating: selectedRating ?? this.selectedRating,
    );
  }
}
