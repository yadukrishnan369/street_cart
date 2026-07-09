import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_state.dart';
import 'package:street_cart/shared/components/customer_bottom_navigation.dart';
import 'package:street_cart/shared/components/customer_search_bar.dart';
import 'package:street_cart/features/customer/products/presentation/pages/wishlist_page.dart';
import 'package:street_cart/features/customer/products/presentation/utils/products_helper.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/products_list_view.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/products_refresh_indicator.dart';

class CustomerProductsPage extends StatefulWidget {
  final String initialSearchQuery;
  final String initialSelectedSort;
  final RangeValues? initialPriceRange;
  final Set<String> initialSelectedCategories;
  final String? initialSelectedRating;
  final Set<String>? initialSelectedColors;
  final Set<String>? initialSelectedSizes;
  final bool shouldFocusSearch;

  const CustomerProductsPage({
    super.key,
    this.initialSearchQuery = "",
    this.initialSelectedSort = "Newest",
    this.initialPriceRange,
    this.initialSelectedCategories = const {'All'},
    this.initialSelectedRating,
    this.initialSelectedColors,
    this.initialSelectedSizes,
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
            initialSelectedColors: widget.initialSelectedColors,
            initialSelectedSizes: widget.initialSelectedSizes,
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
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const HomePage(),
                    transitionDuration: Duration.zero,
                  ),
                );
              }
            },
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
                  MaterialPageRoute(builder: (context) => const WishlistPage()),
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
        body: Column(
          children: [
            BlocBuilder<CustomerProductsBloc, CustomerProductsState>(
              buildWhen: (previous, current) =>
                  previous.runtimeType != current.runtimeType ||
                  (previous is CustomerProductsLoaded &&
                      current is CustomerProductsLoaded &&
                      previous.searchQuery != current.searchQuery),
              builder: (context, state) {
                return CustomSearchBar(
                  hintText: "Search shirts, shoes...",
                  controller: _searchController,
                  autofocus: widget.shouldFocusSearch,
                  onChanged: (val) {
                    final bloc = context.read<CustomerProductsBloc>();
                    if (bloc.state is CustomerProductsLoaded) {
                      final loaded = bloc.state as CustomerProductsLoaded;
                      bloc.add(
                        UpdateFilters(
                          searchQuery: val,
                          selectedCategories: loaded.selectedCategories,
                          selectedSort: loaded.selectedSort,
                          priceRange: loaded.priceRange,
                          selectedRating: loaded.selectedRating,
                          selectedColors: loaded.selectedColors,
                          selectedSizes: loaded.selectedSizes,
                        ),
                      );
                    }
                  },
                  onFilterTap: state is CustomerProductsLoaded
                      ? () {
                          final loaded = state;
                          final categoriesList =
                              ProductsHelper.extractCategories(
                                loaded.allProducts,
                              );
                          ProductsHelper.showFilterBottomSheet(
                            context,
                            loaded,
                            categoriesList,
                          );
                        }
                      : null,
                );
              },
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: ProductsRefreshIndicator(
                onRefreshStarted: () {
                  _searchController.clear();
                },
                child: ProductsListView(
                  initialSearchQuery: widget.initialSearchQuery,
                  initialSelectedSort: widget.initialSelectedSort,
                  initialPriceRange: widget.initialPriceRange,
                  initialSelectedCategories: widget.initialSelectedCategories,
                  initialSelectedRating: widget.initialSelectedRating,
                  initialSelectedColors: widget.initialSelectedColors,
                  initialSelectedSizes: widget.initialSelectedSizes,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomerBottomNavigation(currentIndex: 0),
      ),
    );
  }
}
