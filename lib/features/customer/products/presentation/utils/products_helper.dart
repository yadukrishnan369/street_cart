import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_state.dart';
import 'package:street_cart/features/customer/products/presentation/pages/product_filter_page.dart';

class ProductsHelper {
  static List<String> extractCategories(List<ProductModel> products) {
    final categoriesList = ['All'];
    final parsedCats = products.map((p) => p.category).toSet().toList();
    categoriesList.addAll(parsedCats);
    return categoriesList;
  }

  static Map<String, String> createShopNamesMap(List<ShopProfileModel> shops) {
    return {for (final s in shops) s.uid: s.shopName};
  }

  static Future<void> showFilterBottomSheet(
    BuildContext context,
    CustomerProductsLoaded state,
    List<String> categories,
  ) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFilterPage(
          allProducts: state.allProducts,
          categories: categories,
          selectedSort: state.selectedSort,
          priceRange: state.priceRange,
          selectedCategories: state.selectedCategories,
          selectedRating: state.selectedRating,
          selectedColors: state.selectedColors,
          selectedSizes: state.selectedSizes,
        ),
        fullscreenDialog: true,
      ),
    );

    if (result != null && context.mounted) {
      context.read<CustomerProductsBloc>().add(
            UpdateFilters(
              searchQuery: state.searchQuery,
              selectedSort: result['selectedSort'] ?? 'Newest',
              priceRange: result['priceRange'] ?? const RangeValues(0, 10000),
              selectedCategories: Set<String>.from(
                result['selectedCategories'] ?? {'All'},
              ),
              selectedRating: result['selectedRating'],
              selectedColors: Set<String>.from(
                result['selectedColors'] ?? <String>{},
              ),
              selectedSizes: Set<String>.from(
                result['selectedSizes'] ?? <String>{},
              ),
            ),
          );
    }
  }
}
