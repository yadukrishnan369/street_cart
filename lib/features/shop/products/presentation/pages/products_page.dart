import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/products_ui_cubit.dart';
import 'package:street_cart/features/shop/products/presentation/pages/add_edit_product_page.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_search_text_field.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/products_tab_bar.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/products_tab_bar_view.dart';
import 'package:street_cart/features/shop/products/presentation/utils/products_page_helper.dart';
import 'package:street_cart/shared/components/shop_bottom_navigation.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/shimmer/shop_products_shimmer.dart';
import 'package:street_cart/features/shop/home/presentation/pages/shop_home_page.dart';

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
    if (authState is ShopStatusLoaded) {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShopProductsBloc>(create: (context) => _productsBloc),
        BlocProvider<ProductsUiCubit>(create: (context) => ProductsUiCubit()),
      ],
      child: BlocListener<ShopProductsBloc, ShopProductsState>(
        listener: (context, state) {
          if (state is ShopProductsOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ShopAppColors.success,
              ),
            );
          } else if (state is ShopProductsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: ShopAppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<ProductsUiCubit, ProductsUiState>(
          builder: (context, uiState) {
            return Scaffold(
              backgroundColor: ShopAppColors.background,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: ShopAppColors.textPrimary,
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
                title: uiState.isSearching
                    ? ProductSearchTextField(
                        controller: _searchController,
                        productsBloc: _productsBloc,
                      )
                    : Text('Products', style: ShopAppTextStyles.heading3),
                actions: [
                  IconButton(
                    icon: Icon(
                      uiState.isSearching ? Icons.close : Icons.search,
                      color: ShopAppColors.textPrimary,
                    ),
                    onPressed: () {
                      if (uiState.isSearching) {
                        context.read<ProductsUiCubit>().toggleSearch(false);
                        _searchController.clear();
                        _productsBloc.add(const SearchProductsEvent(''));
                      } else {
                        context.read<ProductsUiCubit>().toggleSearch(true);
                      }
                    },
                  ),
                  BlocBuilder<ShopProductsBloc, ShopProductsState>(
                    builder: (context, state) {
                      final isFiltered =
                          state is ShopProductsLoaded &&
                          state.selectedCategories.isNotEmpty &&
                          !state.selectedCategories.contains('All');
                      List<String> categories = ['All'];
                      if (state is ShopProductsLoaded) {
                        categories = ProductsPageHelper.extractCategories(
                          state.allProducts,
                        );
                      }
                      return IconButton(
                        icon: Icon(
                          Icons.filter_list,
                          color: isFiltered
                              ? ShopAppColors.primary
                              : ShopAppColors.textPrimary,
                        ),
                        onPressed: () => ProductsPageHelper.showCategoryFilter(
                          context,
                          _productsBloc,
                          categories,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 8.w),
                ],
                bottom: ProductsTabBar(controller: _tabController),
              ),
              body: BlocBuilder<ShopProductsBloc, ShopProductsState>(
                buildWhen: (previous, current) =>
                    current is ShopProductsLoaded ||
                    current is ShopProductsLoading ||
                    current is ShopProductsInitial,
                builder: (context, state) {
                  if (state is ShopProductsLoading ||
                      state is ShopProductsInitial) {
                    return const ShopProductsShimmer(itemCount: 5);
                  }

                  if (state is ShopProductsLoaded) {
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditProductPage(
                        shopId: _shopId,
                        productsBloc: _productsBloc,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
              bottomNavigationBar: const ShopBottomNavigation(currentIndex: 1),
            );
          },
        ),
      ),
    );
  }
}
