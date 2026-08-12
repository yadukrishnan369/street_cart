import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';
import 'package:street_cart/features/shop/products/presentation/pages/add_edit_product_page.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_search_text_field.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/products_tab_bar.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/products_tab_bar_view.dart';
import 'package:street_cart/features/shop/products/presentation/utils/products_page_helper.dart';
import 'package:street_cart/shared/components/shop_bottom_navigation.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/shimmer/shop_products_shimmer.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/app_error_view.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// Products Page
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ShopProductsBloc _productsBloc;
  final TextEditingController _searchController = TextEditingController();
  String _shopId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _productsBloc = sl<ShopProductsBloc>();

    final authState = context.read<ShopAuthBloc>().state;
    if (authState.status == ShopAuthStatus.authenticated) {
      _shopId = authState.shop?.uid ?? '';
      _productsBloc.add(LoadShopProductsEvent(_shopId));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopProductsBloc>(
      create: (context) => _productsBloc,
      child: BlocListener<ShopProductsBloc, ShopProductsState>(
        listener: (context, state) {
          if (state.status == ShopProductsStatus.operationSuccess) {
            CustomSnackBar.show(
              context,
              message: state.successMessage ?? 'Operation successful',
            );
          } else if (state.status == ShopProductsStatus.error) {
            CustomSnackBar.show(
              context,
              message: state.errorMessage ?? 'An error occurred',
              isError: true,
            );
          }
          if (state.searchQuery.isEmpty && _searchController.text.isNotEmpty) {
            _searchController.clear();
          }
        },
        child: BlocBuilder<ShopProductsBloc, ShopProductsState>(
          builder: (context, state) {
            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;

            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: isDark
                    ? ShopAppColors.darkBackground
                    : Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark
                        ? ShopAppColors.darkTextPrimary
                        : ShopAppColors.textPrimary,
                  ),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const ShopHomePage(),
                          transitionDuration: Duration.zero,
                        ),
                      );
                    }
                  },
                ),
                // Page Header / Search Field
                title: state.isSearching
                    ? ProductSearchTextField(
                        controller: _searchController,
                        productsBloc: _productsBloc,
                      )
                    : Text(
                        'Products',
                        style: isDark
                            ? ShopAppTextStyles.heading3.copyWith(
                                color: ShopAppColors.darkTextPrimary,
                              )
                            : ShopAppTextStyles.heading3,
                      ),
                actions: [
                  IconButton(
                    icon: Icon(
                      state.isSearching ? Icons.close : Icons.search,
                      color: isDark
                          ? ShopAppColors.darkTextPrimary
                          : ShopAppColors.textPrimary,
                    ),
                    onPressed: () {
                      if (state.isSearching) {
                        _productsBloc.add(const ToggleSearchEvent(false));
                        _searchController.clear();
                        _productsBloc.add(const SearchProductsEvent(''));
                      } else {
                        _productsBloc.add(const ToggleSearchEvent(true));
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color:
                          (state.selectedCategories.isNotEmpty &&
                              !state.selectedCategories.contains('All'))
                          ? ShopAppColors.primary
                          : (isDark
                                ? ShopAppColors.darkTextPrimary
                                : ShopAppColors.textPrimary),
                    ),
                    onPressed: () => ProductsPageHelper.showCategoryFilter(
                      context,
                      _productsBloc,
                      ProductsPageHelper.extractCategories(state.allProducts),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
                // Products Tab Bar
                bottom: ProductsTabBar(controller: _tabController),
              ),
              body: BlocBuilder<ShopProductsBloc, ShopProductsState>(
                buildWhen: (previous, current) =>
                    current.status == ShopProductsStatus.loaded ||
                    current.status == ShopProductsStatus.loading ||
                    current.status == ShopProductsStatus.initial ||
                    current.status == ShopProductsStatus.error,
                builder: (context, state) {
                  if (state.status == ShopProductsStatus.loading ||
                      state.status == ShopProductsStatus.initial) {
                    return const ShopProductsShimmer(itemCount: 5);
                  }
                  if (state.status == ShopProductsStatus.error) {
                    // App Error View
                    return AppErrorView(
                      message: state.errorMessage ?? 'An error occurred',
                      onRetry: () {
                        _productsBloc.add(LoadShopProductsEvent(_shopId));
                      },
                    );
                  }
                  if (state.status == ShopProductsStatus.loaded) {
                    // Products Tab Bar View
                    return ProductsTabBarView(
                      tabController: _tabController,
                      allProducts: state.filteredProducts,
                      shopId: _shopId,
                      productsBloc: _productsBloc,
                    );
                  }
                  return const Center(child: Text('No products found.'));
                },
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: ShopAppColors.primary,
                shape: const CircleBorder(),
                onPressed: () {
                  // Navigate to Add Edit Product Page
                  Navigator.push(
                    context,
                    AppPageTransitions.slide(
                      AddEditProductPage(
                        shopId: _shopId,
                        productsBloc: _productsBloc,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
              // Bottom Navigation Bar
              bottomNavigationBar: const ShopBottomNavigation(currentIndex: 1),
            );
          },
        ),
      ),
    );
  }
}
