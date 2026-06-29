import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/core/utils/logger.dart';
import 'package:street_cart/features/customer/products/domain/usecases/get_customer_products.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'customer_products_event.dart';
import 'customer_products_state.dart';

class CustomerProductsBloc extends Bloc<CustomerProductsEvent, CustomerProductsState> {
  final GetCustomerProducts getCustomerProducts;
  final SharedPreferences _sharedPreferences;

  CustomerProductsBloc({
    required this.getCustomerProducts,
    required SharedPreferences sharedPreferences,
  })  : _sharedPreferences = sharedPreferences,
        super(CustomerProductsInitial()) {
    on<FetchCustomerProducts>(_onFetchCustomerProducts);
    on<UpdateFilters>(_onUpdateFilters);
  }

  Future<void> _onFetchCustomerProducts(
    FetchCustomerProducts event,
    Emitter<CustomerProductsState> emit,
  ) async {
    final locationEnabled = _sharedPreferences.getBool('locationServices') ?? false;
    if (!locationEnabled) {
      emit(CustomerProductsLocationDisabled());
      return;
    }

    emit(CustomerProductsLoading());
    try {
      final data = await getCustomerProducts();
      final allProducts = data.products;
      final shops = data.shops;

      final searchQuery = event.initialSearchQuery ?? "";
      final selectedCategories = event.initialSelectedCategories ?? const {'All'};
      final selectedSort = event.initialSelectedSort ?? "Newest";
      final priceRange = event.initialPriceRange ?? const RangeValues(0, 10000);
      final selectedRating = event.initialSelectedRating;

      final filteredProducts = _filterAndSort(
        allProducts: allProducts,
        shops: shops,
        searchQuery: searchQuery,
        selectedCategories: selectedCategories,
        selectedSort: selectedSort,
        priceRange: priceRange,
        selectedRating: selectedRating,
      );

      emit(CustomerProductsLoaded(
        allProducts: allProducts,
        filteredProducts: filteredProducts,
        shops: shops,
        searchQuery: searchQuery,
        selectedCategories: selectedCategories,
        selectedSort: selectedSort,
        priceRange: priceRange,
        selectedRating: selectedRating,
      ));
    } catch (e, stack) {
      AppLogger.error('Failed to fetch customer products', e, stack);
      emit(CustomerProductsError(message: 'Failed to load products.'));
    }
  }

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
      );

      emit(CustomerProductsLoaded(
        allProducts: currentState.allProducts,
        filteredProducts: filtered,
        shops: currentState.shops,
        searchQuery: event.searchQuery,
        selectedCategories: event.selectedCategories,
        selectedSort: event.selectedSort,
        priceRange: event.priceRange,
        selectedRating: event.selectedRating,
      ));
    }
  }

  List<ProductModel> _filterAndSort({
    required List<ProductModel> allProducts,
    required List<ShopProfileModel> shops,
    required String searchQuery,
    required Set<String> selectedCategories,
    required String selectedSort,
    required RangeValues priceRange,
    required String? selectedRating,
  }) {
    final shopNames = {
      for (final s in shops) s.uid: s.shopName,
    };

    final filtered = allProducts.where((product) {
      final matchQuery =
          product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (shopNames[product.shopId] ?? '').toLowerCase().contains(searchQuery.toLowerCase());

      final matchCat =
          selectedCategories.contains('All') ||
          selectedCategories.isEmpty ||
          selectedCategories.any(
            (cat) => cat.toLowerCase() == product.category.toLowerCase(),
          );

      final productPrice = product.offerPrice ?? product.originalPrice;
      final matchPrice =
          productPrice >= priceRange.start &&
          productPrice <= priceRange.end;

      return matchQuery && matchCat && matchPrice;
    }).toList();

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

