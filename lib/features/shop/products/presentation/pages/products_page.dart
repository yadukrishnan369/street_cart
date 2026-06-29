import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';
import 'package:street_cart/features/shop/products/presentation/pages/add_edit_product_page.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/category_filter_bottom_sheet.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_list_item.dart';
import 'package:street_cart/shared/components/shop_bottom_navigation.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/di/dependency_injection.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ShopProductsBloc _productsBloc;
  bool _isSearching = false;
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
    } else {
      print("Auth state is not ShopStatusLoaded: $authState");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showCategoryFilter(BuildContext context, List<String> categories) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (modalContext) {
        return BlocProvider.value(
          value: _productsBloc,
          child: CategoryFilterBottomSheet(
            productsBloc: _productsBloc,
            categories: categories,
          ),
        );
      },
    );
  }

  void _confirmDelete(ProductModel product) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Delete Product',
        content:
            'Are you sure you want to delete this product? This action cannot be undone.',
        confirmText: 'Delete',
        confirmColor: ShopAppColors.error,
        onConfirm: () {
          Navigator.pop(dialogContext);
          // Double confirmation as requested
          showDialog(
            context: context,
            builder: (doubleConfirmContext) => ConfirmationModal(
              title: 'Confirm Deletion',
              content:
                  'Please confirm once more. Delete "${product.name}" permanently?',
              confirmText: 'Permanently Delete',
              confirmColor: ShopAppColors.error,
              onConfirm: () {
                Navigator.pop(doubleConfirmContext);
                _productsBloc.add(DeleteProductEvent(_shopId, product.id));
              },
              onCancel: () => Navigator.pop(doubleConfirmContext),
            ),
          );
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShopProductsBloc>(
      create: (context) => _productsBloc,
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
        child: Scaffold(
          backgroundColor: ShopAppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search product...',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16.sp),
                    onChanged: (val) {
                      _productsBloc.add(SearchProductsEvent(val));
                    },
                  )
                : Text('Products', style: ShopAppTextStyles.heading3),
            actions: [
              IconButton(
                icon: Icon(
                  _isSearching ? Icons.close : Icons.search,
                  color: ShopAppColors.textPrimary,
                ),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _isSearching = false;
                      _searchController.clear();
                      _productsBloc.add(const SearchProductsEvent(''));
                    } else {
                      _isSearching = true;
                    }
                  });
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
                    final productCats = state.allProducts
                        .map((p) => p.category)
                        .where((cat) => cat.isNotEmpty)
                        .toSet()
                        .toList();
                    categories.addAll(productCats);
                  }
                  return IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: isFiltered
                          ? ShopAppColors.primary
                          : ShopAppColors.textPrimary,
                    ),
                    onPressed: () => _showCategoryFilter(context, categories),
                  );
                },
              ),
              SizedBox(width: 8.w),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48.h),
              child: Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: ShopAppColors.primary,
                  indicatorWeight: 3.h,
                  labelColor: ShopAppColors.primary,
                  unselectedLabelColor: ShopAppColors.textTertiary,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: const [
                    Tab(text: 'All Products'),
                    Tab(text: 'Active'),
                    Tab(text: 'Out of Stock'),
                  ],
                ),
              ),
            ),
          ),
          body: BlocBuilder<ShopProductsBloc, ShopProductsState>(
            buildWhen: (previous, current) =>
                current is ShopProductsLoaded ||
                current is ShopProductsLoading ||
                current is ShopProductsInitial,
            builder: (context, state) {
              if (state is ShopProductsLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ShopAppColors.primary,
                  ),
                );
              }

              if (state is ShopProductsLoaded) {
                final all = state.filteredProducts;
                final active = all.where((p) => p.stockQuantity > 0).toList();
                final outOfStock = all
                    .where((p) => p.stockQuantity <= 0)
                    .toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProductList(all),
                    _buildProductList(active),
                    _buildProductList(outOfStock),
                  ],
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
        ),
      ),
    );
  }

  Widget _buildProductList(List<ProductModel> products) {
    if (products.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          _productsBloc.add(LoadShopProductsEvent(_shopId));
        },
        color: ShopAppColors.primary,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: 400.h,
              child: Center(
                child: Text(
                  'No products available in this tab.',
                  style: ShopAppTextStyles.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _productsBloc.add(LoadShopProductsEvent(_shopId));
      },
      color: ShopAppColors.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductListItem(
            product: product,
            shopId: _shopId,
            productsBloc: _productsBloc,
            onDeleteTap: () => _confirmDelete(product),
          );
        },
      ),
    );
  }
}
