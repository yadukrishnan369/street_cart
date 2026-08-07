import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/core/utils/logger.dart';
import 'package:street_cart/features/customer/products/domain/usecases/get_customer_products.dart';
import 'package:street_cart/features/customer/review/domain/usecases/get_product_reviews.dart';
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

  final Set<String> orderCats = {};
  final Map<String, int> recentSales = {};

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
      if (searchQuery.isNotEmpty) {
        _saveQueryToHistory(searchQuery);
      }
      final selectedCategories =
          event.initialSelectedCategories ?? const {'All'};
      final selectedSort = event.initialSelectedSort ?? 'Newest';
      final priceRange = event.initialPriceRange ?? const RangeValues(0, 10000);
      final selectedRating = event.initialSelectedRating;
      final selectedColors = event.initialSelectedColors ?? const <String>{};
      final selectedSizes = event.initialSelectedSizes ?? const <String>{};

      // Load recommended / trending order data
      orderCats.clear();
      recentSales.clear();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final ordersSnap = await FirebaseFirestore.instance
              .collection('orders')
              .where('customer_id', isEqualTo: user.uid)
              .get();
          for (final doc in ordersSnap.docs) {
            final items = doc.data()['items'] as List<dynamic>? ?? [];
            for (final item in items) {
              final pId = item['product_id'] as String?;
              if (pId != null) {
                final matchedProduct = allProducts.firstWhere(
                  (p) => p.id == pId,
                  orElse: () => ProductModel(
                    id: '',
                    shopId: '',
                    name: '',
                    originalPrice: 0.0,
                    description: '',
                    stockQuantity: 0,
                    category: '',
                    sizeStandard: '',
                  ),
                );
                if (matchedProduct.id.isNotEmpty &&
                    matchedProduct.category.isNotEmpty) {
                  orderCats.add(matchedProduct.category);
                }
              }
            }
          }
        } catch (_) {}

        try {
          final tenDaysAgo = DateTime.now().subtract(const Duration(days: 10));
          final recentOrdersSnap = await FirebaseFirestore.instance
              .collection('orders')
              .where(
                'created_at',
                isGreaterThanOrEqualTo: Timestamp.fromDate(tenDaysAgo),
              )
              .get();
          for (final doc in recentOrdersSnap.docs) {
            final items = doc.data()['items'] as List<dynamic>? ?? [];
            for (final item in items) {
              final pId = item['product_id'] as String?;
              final qty = (item['quantity'] as num?)?.toInt() ?? 1;
              if (pId != null) {
                recentSales[pId] = (recentSales[pId] ?? 0) + qty;
              }
            }
          }
        } catch (_) {}
      }

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
    if (event.searchQuery.isNotEmpty) {
      _saveQueryToHistory(event.searchQuery);
    }
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

    emit(
      ProductDetailState(
        selectedColor: selectedColor,
        selectedSize: selectedSize,
        variantWarningMessage: variantWarningMessage,
        reviews: const [],
      ),
    );

    try {
      final reviews = await getProductReviews(product.id);
      if (!isClosed && state is ProductDetailState) {
        emit((state as ProductDetailState).copyWith(reviews: reviews));
      }
    } catch (e) {
      // Keep empty if failed
    }
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

    var filtered = allProducts.where((product) {
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

      // Rating Filter logic
      bool matchRating = selectedRating == null;
      if (!matchRating) {
        final minRating = double.tryParse(selectedRating[0]) ?? 0.0;
        matchRating = product.rating >= minRating;
      }

      return matchQuery &&
          matchCat &&
          matchPrice &&
          matchColor &&
          matchSize &&
          matchRating;
    }).toList();

    // Sort/Filter Filtered Products by Selected Sort Option
    if (selectedSort == 'Recommended') {
      final recentQueries =
          _sharedPreferences.getStringList('recent_queries') ?? <String>[];
      final recommendedSet = <String>{};
      final recommendedList = <ProductModel>[];

      // Add products matching recent search queries first
      if (recentQueries.isNotEmpty) {
        for (final query in recentQueries) {
          final keywords = <String>{};
          final words = query.split(RegExp(r'\s+'));
          for (final word in words) {
            final cleaned = word.trim().toLowerCase();
            if (cleaned.length >= 3) {
              keywords.add(cleaned);
            }
          }
          if (keywords.isNotEmpty) {
            final queryMatches = filtered.where((p) {
              if (recommendedSet.contains(p.id)) return false;
              final nameLower = p.name.toLowerCase();
              final catLower = p.category.toLowerCase();
              final descLower = p.description.toLowerCase();
              return keywords.any((kw) {
                return nameLower.contains(kw) ||
                    catLower.contains(kw) ||
                    descLower.contains(kw);
              });
            }).toList();
            for (final p in queryMatches) {
              recommendedList.add(p);
              recommendedSet.add(p.id);
            }
          }
        }
      }

      // Add products matching previously ordered product categories
      if (orderCats.isNotEmpty) {
        final orderCatProducts = filtered
            .where(
              (p) => orderCats.any(
                (cat) => cat.toLowerCase() == p.category.toLowerCase(),
              ),
            )
            .toList();
        for (final p in orderCatProducts) {
          if (!recommendedSet.contains(p.id)) {
            recommendedList.add(p);
            recommendedSet.add(p.id);
          }
        }
      }

      filtered = recommendedList;
    } else if (selectedSort == 'Trending') {
      filtered.sort((a, b) {
        final salesA = recentSales[a.id] ?? 0;
        final salesB = recentSales[b.id] ?? 0;
        if (salesA != salesB) {
          return salesB.compareTo(salesA);
        }
        if (a.salesCount != b.salesCount) {
          return b.salesCount.compareTo(a.salesCount);
        }
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
    } else if (selectedSort == 'Newest') {
      filtered.sort((a, b) {
        if (a.createdAt == null && b.createdAt == null) return 0;
        if (a.createdAt == null) return 1;
        if (b.createdAt == null) return -1;
        return b.createdAt!.compareTo(a.createdAt!);
      });
    } else if (selectedSort == 'Popularity') {
      filtered.sort((a, b) {
        final scoreA = a.salesCount + a.rating;
        final scoreB = b.salesCount + b.rating;
        return scoreB.compareTo(scoreA);
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
    } else if (selectedSort == 'Best Sellers') {
      filtered.sort((a, b) => b.salesCount.compareTo(a.salesCount));
    }

    return filtered;
  }

  // Save Query history for Recommended Products
  void _saveQueryToHistory(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return;

    final recent =
        _sharedPreferences.getStringList('recent_queries') ?? <String>[];
    if (recent.contains(trimmed)) {
      recent.remove(trimmed);
    }
    recent.insert(0, trimmed);
    if (recent.length > 5) {
      recent.removeLast();
    }
    _sharedPreferences.setStringList('recent_queries', recent);
  }

  @override
  Future<void> close() {
    if (state is CustomerProductsLoaded) {
      final query = (state as CustomerProductsLoaded).searchQuery;
      _saveQueryToHistory(query);
    }
    return super.close();
  }
}
