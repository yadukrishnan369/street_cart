import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_state.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/pages/product_filter_page.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

class ProductsHelper {
  // Fetch Full Category List with 'All'
  static List<String> extractCategories(List<ProductModel> products) {
    final categoriesList = ['All'];
    final parsedCats = products.map((p) => p.category).toSet().toList();
    categoriesList.addAll(parsedCats);
    return categoriesList;
  }

  // Create Shop Name for Fast Searching
  static Map<String, String> createShopNamesMap(List<ShopProfileModel> shops) {
    return {for (final s in shops) s.uid: s.shopName};
  }

  // Opens Filter Page
  static Future<void> showFilterBottomSheet(
    BuildContext context,
    CustomerProductsLoaded state,
    List<String> categories,
  ) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      AppPageTransitions.slideFromBottom(
        ProductFilterPage(
          allProducts: state.allProducts,
          categories: categories,
          selectedSort: state.selectedSort,
          priceRange: state.priceRange,
          selectedCategories: state.selectedCategories,
          selectedRating: state.selectedRating,
          selectedColors: state.selectedColors,
          selectedSizes: state.selectedSizes,
        ),
      ),
    );

    // Returned, Filter Result to the Products Page
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

  // Get Stock Quantity for the selected color and size
  static int getVariantStock(
    ProductModel product,
    String? selectedColor,
    String? selectedSize,
  ) {
    if (selectedColor == null || selectedSize == null) return 0;
    return product.stockForVariant(selectedColor, selectedSize);
  }

  // Get Image List for the Selected Color
  static List<String> getImagesForColor(
    ProductModel product,
    String? selectedColor,
  ) {
    if (selectedColor == null) return product.displayImages;
    return product.imagesForColor(selectedColor);
  }

  // Get Category List for the Filter UI
  static List<String> getDisplayCategories(ProductFilterState state) {
    final filtered = state.allProducts
        .map((p) => p.category)
        .toSet()
        .where(
          (c) => c.toLowerCase().contains(state.categoryQuery.toLowerCase()),
        )
        .toList();

    final displayCats = ['All', ...filtered];
    return displayCats;
  }

  // Check 'see all' Button Should shown or Not
  static bool shouldShowSeeAll(
    ProductFilterState state,
    List<String> displayCats,
  ) {
    return displayCats.length > 7 &&
        !state.showAllCategories &&
        state.categoryQuery.isEmpty;
  }

  // Get Available Sizes for Specific Category and Color
  static Set<String> getSizesForCategory(ProductFilterState state, String cat) {
    final Set<String> sizesForCat = {};
    final useAllColors = state.selectedColors.isEmpty;

    for (final p in state.allProducts) {
      if (p.category.toLowerCase() != cat.toLowerCase()) continue;

      if (useAllColors) {
        // Include all Sizes from this Category
        sizesForCat.addAll(p.allSizes);
      } else {
        // Include Sizes for the Selected Colors with Available Stock
        for (final variant in p.variants) {
          if (state.selectedColors.contains(variant.colorName)) {
            for (final entry in variant.sizes.entries) {
              if (entry.value > 0) sizesForCat.add(entry.key);
            }
          }
        }
        if (!p.hasVariants &&
            p.colors.any((c) => state.selectedColors.contains(c))) {
          sizesForCat.addAll(p.allSizes);
        }
      }
    }

    return sizesForCat;
  }
}
