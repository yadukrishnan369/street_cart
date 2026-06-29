import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_state.dart';
import 'package:street_cart/shared/components/customer_bottom_navigation.dart';
import 'package:street_cart/shared/components/customer_search_bar.dart';
import 'package:street_cart/features/customer/products/presentation/pages/product_filter_page.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/products_location_disabled.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/products_empty_state.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/products_grid.dart';
import 'package:street_cart/features/customer/products/presentation/pages/wishlist_page.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_state.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class CustomerProductsPage extends StatefulWidget {
  final String initialSearchQuery;
  final String initialSelectedSort;
  final RangeValues initialPriceRange;
  final Set<String> initialSelectedCategories;
  final String? initialSelectedRating;
  final bool shouldFocusSearch;

  const CustomerProductsPage({
    super.key,
    this.initialSearchQuery = "",
    this.initialSelectedSort = "Newest",
    this.initialPriceRange = const RangeValues(0, 10000),
    this.initialSelectedCategories = const {'All'},
    this.initialSelectedRating,
    this.shouldFocusSearch = false,
  });

  @override
  State<CustomerProductsPage> createState() => _CustomerProductsPageState();
}

class _CustomerProductsPageState extends State<CustomerProductsPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CustomerProductsBloc>()
        ..add(
          FetchCustomerProducts(
            initialSearchQuery: widget.initialSearchQuery,
            initialSelectedSort: widget.initialSelectedSort,
            initialPriceRange: widget.initialPriceRange,
            initialSelectedCategories: widget.initialSelectedCategories,
            initialSelectedRating: widget.initialSelectedRating,
          ),
        ),
      child: Scaffold(
        backgroundColor: CustomerAppColors.background,
        appBar: AppBar(
          backgroundColor: CustomerAppColors.surface,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: CustomerAppColors.textPrimary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text(
            'Products',
            style: TextStyle(
              color: CustomerAppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WishlistPage(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      color: CustomerAppColors.textPrimary,
                      size: 20.sp,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Wishlist',
                      style: TextStyle(
                        color: CustomerAppColors.textPrimary,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<CustomerProductsBloc, CustomerProductsState>(
          builder: (context, state) {
            if (state is CustomerProductsInitial ||
                state is CustomerProductsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: CustomerAppColors.primary,
                ),
              );
            } else if (state is CustomerProductsLocationDisabled) {
              return ProductsLocationDisabled(
                onRefreshLocation: () {
                  context.read<CustomerProductsBloc>().add(
                    FetchCustomerProducts(
                      initialSearchQuery: widget.initialSearchQuery,
                      initialSelectedSort: widget.initialSelectedSort,
                      initialPriceRange: widget.initialPriceRange,
                      initialSelectedCategories:
                          widget.initialSelectedCategories,
                      initialSelectedRating: widget.initialSelectedRating,
                    ),
                  );
                },
              );
            } else if (state is CustomerProductsError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: CustomerAppColors.error,
                  ),
                ),
              );
            } else if (state is CustomerProductsLoaded) {
              final allProducts = state.allProducts;
              final filteredProducts = state.filteredProducts;
              final shopNames = {
                for (final s in state.shops) s.uid: s.shopName,
              };

              // Get unique categories list dynamically
              final categoriesList = ['All'];
              final parsedCats = allProducts
                  .map((p) => p.category)
                  .toSet()
                  .toList();
              categoriesList.addAll(parsedCats);

              return Column(
                children: [
                  CustomSearchBar(
                    hintText: "Search shirts, shoes...",
                    controller: _searchController,
                    autofocus: widget.shouldFocusSearch,
                    onChanged: (val) {
                      context.read<CustomerProductsBloc>().add(
                        UpdateFilters(
                          searchQuery: val,
                          selectedCategories: state.selectedCategories,
                          selectedSort: state.selectedSort,
                          priceRange: state.priceRange,
                          selectedRating: state.selectedRating,
                        ),
                      );
                    },
                    onFilterTap: () =>
                        _showFilterBottomSheet(context, state, categoriesList),
                  ),

                  SizedBox(height: 12.h),

                  // Grid of products
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? const ProductsEmptyState()
                        : BlocBuilder<WishlistBloc, WishlistState>(
                            builder: (context, wishlistState) {
                              final wishlistedIds = wishlistState is WishlistLoaded
                                  ? wishlistState.items
                                      .map((i) => i.product.id)
                                      .toSet()
                                  : <String>{};

                              return ProductsGrid(
                                products: filteredProducts,
                                shops: state.shops,
                                shopNames: shopNames,
                                wishlistedProductIds: wishlistedIds,
                                onFavoriteTap: (product, isWishlisted) {
                                  final shop = state.shops.firstWhere(
                                    (s) => s.uid == product.shopId,
                                  );
                                  if (isWishlisted) {
                                    context.read<WishlistBloc>().add(
                                          RemoveProductFromWishlist(
                                            productId: product.id,
                                          ),
                                        );
                                    CustomSnackBar.show(context, message: 'Removed from wishlist');
                                  } else {
                                    context.read<WishlistBloc>().add(
                                          AddProductToWishlist(
                                            product: product,
                                            shop: shop,
                                          ),
                                        );
                                    CustomSnackBar.show(context, message: 'Added to wishlist');
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
        bottomNavigationBar: const CustomerBottomNavigation(currentIndex: 0),
      ),
    );
  }

  void _showFilterBottomSheet(
    BuildContext context,
    CustomerProductsLoaded state,
    List<String> categories,
  ) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFilterPage(
          categories: categories,
          selectedSort: state.selectedSort,
          priceRange: state.priceRange,
          selectedCategories: state.selectedCategories,
          selectedRating: state.selectedRating,
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
        ),
      );
    }
  }
}
