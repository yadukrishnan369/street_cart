import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/core/utils/logger.dart';
import 'package:street_cart/features/customer/products/domain/usecases/get_customer_products.dart';
import 'package:street_cart/features/customer/review/domain/usecases/get_product_reviews.dart';
import 'package:street_cart/features/customer/review/data/models/review_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'customer_products_event.dart';
import 'customer_products_state.dart';

// Customer Products Bloc
class CustomerProductsBloc
    extends Bloc<CustomerProductsEvent, CustomerProductsState> {
  final GetCustomerProducts getCustomerProducts;
  final SharedPreferences _sharedPreferences;
  final GetProductReviews getProductReviews;

  CustomerProductsBloc({
    required this.getCustomerProducts,
    required SharedPreferences sharedPreferences,
    required this.getProductReviews,
  }) : _sharedPreferences = sharedPreferences,
       super(CustomerProductsInitial()) {
    on<FetchCustomerProducts>(_onFetchCustomerProducts);
    on<UpdateFilters>(_onUpdateFilters);
    on<InitProductDetail>(_onInitProductDetail);
    on<SelectProductColor>(_onSelectProductColor);
    on<SelectProductSize>(_onSelectProductSize);
    on<UpdateCarouselIndex>(_onUpdateCarouselIndex);
  }

  // Fetch Nearby Products and Shops
  Future<void> _onFetchCustomerProducts(
    FetchCustomerProducts event,
    Emitter<CustomerProductsState> emit,
  ) async {
    final locationEnabled =
        _sharedPreferences.getBool('locationServices') ?? false;
    if (!locationEnabled) {
      emit(CustomerProductsLocationDisabled());
      return;
    }

    emit(CustomerProductsLoading());
    try {
      final data = await getCustomerProducts();
      final allProducts = data.products;
      final shops = data.shops;

      final searchQuery = event.initialSearchQuery ?? '';
      final selectedCategories =
          event.initialSelectedCategories ?? const {'All'};
      final selectedSort = event.initialSelectedSort ?? 'Newest';
      final priceRange = event.initialPriceRange ?? const RangeValues(0, 10000);
      final selectedRating = event.initialSelectedRating;
      final selectedColors = event.initialSelectedColors ?? const <String>{};
      final selectedSizes = event.initialSelectedSizes ?? const <String>{};

      final filteredProducts = _filterAndSort(
        allProducts: allProducts,
        shops: shops,
        searchQuery: searchQuery,
        selectedCategories: selectedCategories,
        selectedSort: selectedSort,
        priceRange: priceRange,
        selectedRating: selectedRating,
        selectedColors: selectedColors,
        selectedSizes: selectedSizes,
      );

      emit(
        CustomerProductsLoaded(
          allProducts: allProducts,
          filteredProducts: filteredProducts,
          shops: shops,
          searchQuery: searchQuery,
          selectedCategories: selectedCategories,
          selectedSort: selectedSort,
          priceRange: priceRange,
          selectedRating: selectedRating,
          selectedColors: selectedColors,
          selectedSizes: selectedSizes,
        ),
      );
    } catch (e, stack) {
      AppLogger.error('Failed to fetch customer products', e, stack);
      emit(CustomerProductsError(message: e.toString()));
    }
  }

  // Re-Filters and Re-Sorts to Already Loaded Products List
  void _onUpdateFilters(
    UpdateFilters event,
    Emitter<CustomerProductsState> emit,
  ) {
    if (state is CustomerProductsLoaded) {
      final currentState = state as CustomerProductsLoaded;
      final filtered = _filterAndSort(
        allProducts: currentState.allProducts,
        shops: currentState.shops,
        searchQuery: event.searchQuery,
        selectedCategories: event.selectedCategories,
        selectedSort: event.selectedSort,
        priceRange: event.priceRange,
        selectedRating: event.selectedRating,
        selectedColors: event.selectedColors,
        selectedSizes: event.selectedSizes,
      );

      emit(
        CustomerProductsLoaded(
          allProducts: currentState.allProducts,
          filteredProducts: filtered,
          shops: currentState.shops,
          searchQuery: event.searchQuery,
          selectedCategories: event.selectedCategories,
          selectedSort: event.selectedSort,
          priceRange: event.priceRange,
          selectedRating: event.selectedRating,
          selectedColors: event.selectedColors,
          selectedSizes: event.selectedSizes,
        ),
      );
    }
  }

  // Initializes Detail
  Future<void> _onInitProductDetail(
    InitProductDetail event,
    Emitter<CustomerProductsState> emit,
  ) async {
    final product = event.product;
    final colors = product.allColors;
    final sizes = product.allSizes;

    bool hasSavedVariant =
        event.initialColor != null || event.initialSize != null;
    bool isSavedVariantAvailable = false;

    String? selectedColor;
    String? selectedSize;
    String? variantWarningMessage;

    // Validate if the Previous Saved Variant is Still in Stock
    if (hasSavedVariant) {
      if (event.initialColor != null && event.initialSize != null) {
        final hasColor = colors.contains(event.initialColor);
        final hasSize = sizes.contains(event.initialSize);
        final stock = product.stockForVariant(
          event.initialColor!,
          event.initialSize!,
        );
        if (hasColor && hasSize && stock > 0) {
          selectedColor = event.initialColor;
          selectedSize = event.initialSize;
          isSavedVariantAvailable = true;
        }
      }

      if (!isSavedVariantAvailable) {
        variantWarningMessage =
            'The saved variant is unavailable. Please choose another available variant.';
      }
    }

    // Show First Available Color and Size when no Saved Variant
    if (!isSavedVariantAvailable) {
      if (colors.isNotEmpty) selectedColor = colors.first;
      if (sizes.isNotEmpty) selectedSize = sizes.first;
    }

    List<ReviewModel> reviews = [];
    try {
      reviews = await getProductReviews(product.id);
    } catch (e) {
      // Keep empty if failed
    }

    emit(
      ProductDetailState(
        selectedColor: selectedColor,
        selectedSize: selectedSize,
        variantWarningMessage: variantWarningMessage,
        reviews: reviews,
      ),
    );
  }

  // Selects a Color and Resets Sizes
  void _onSelectProductColor(
    SelectProductColor event,
    Emitter<CustomerProductsState> emit,
  ) {
    if (state is ProductDetailState) {
      final current = state as ProductDetailState;
      final sizes = event.product.allSizes;
      final defaultSize = sizes.isNotEmpty ? sizes.first : null;
      emit(
        current.copyWith(selectedColor: event.color, selectedSize: defaultSize),
      );
    }
  }

  // Updates the Selected Size for the Current Detail Page Variant
  void _onSelectProductSize(
    SelectProductSize event,
    Emitter<CustomerProductsState> emit,
  ) {
    if (state is ProductDetailState) {
      final current = state as ProductDetailState;
      emit(current.copyWith(selectedSize: event.size));
    }
  }

  // Updates the Active Image in the Product Carousel
  void _onUpdateCarouselIndex(
    UpdateCarouselIndex event,
    Emitter<CustomerProductsState> emit,
  ) {
    if (state is ProductDetailState) {
      final current = state as ProductDetailState;
      emit(current.copyWith(carouselIndex: event.index));
    }
  }

  // Filter and Sort Logic applied to Product List
  List<ProductModel> _filterAndSort({
    required List<ProductModel> allProducts,
    required List<ShopProfileModel> shops,
    required String searchQuery,
    required Set<String> selectedCategories,
    required String selectedSort,
    required RangeValues priceRange,
    required String? selectedRating,
    required Set<String> selectedColors,
    required Set<String> selectedSizes,
  }) {
    final shopNames = {for (final s in shops) s.uid: s.shopName};

    final filtered = allProducts.where((product) {
      // Match Product name, Description or Shop name By Search query
      final matchQuery =
          product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(
            searchQuery.toLowerCase(),
          ) ||
          (shopNames[product.shopId] ?? '').toLowerCase().contains(
            searchQuery.toLowerCase(),
          );

      // Match By Selected Category
      final matchCat =
          selectedCategories.contains('All') ||
          selectedCategories.isEmpty ||
          selectedCategories.any(
            (cat) => cat.toLowerCase() == product.category.toLowerCase(),
          );

      // Match Product Price Within the Selected Range
      final productPrice = product.offerPrice ?? product.originalPrice;
      final matchPrice =
          productPrice >= priceRange.start && productPrice <= priceRange.end;

      // Color Filter logic
      bool matchColor = selectedColors.isEmpty;
      if (!matchColor) {
        matchColor = product.allColors.any((c) => selectedColors.contains(c));
      }

      // Size Filter logic
      bool matchSize = selectedSizes.isEmpty;
      if (!matchSize) {
        matchSize = product.allSizes.any((s) => selectedSizes.contains(s));
      }

      return matchQuery && matchCat && matchPrice && matchColor && matchSize;
    }).toList();

    // Sort Filtered Products by Selected Sort Option
    if (selectedSort == 'Newest') {
      filtered.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
    } else if (selectedSort == 'Price: Low to High') {
      filtered.sort((a, b) {
        final priceA = a.offerPrice ?? a.originalPrice;
        final priceB = b.offerPrice ?? b.originalPrice;
        return priceA.compareTo(priceB);
      });
    } else if (selectedSort == 'Price: High to Low') {
      filtered.sort((a, b) {
        final priceA = a.offerPrice ?? a.originalPrice;
        final priceB = b.offerPrice ?? b.originalPrice;
        return priceB.compareTo(priceA);
      });
    }

    return filtered;
  }
}
