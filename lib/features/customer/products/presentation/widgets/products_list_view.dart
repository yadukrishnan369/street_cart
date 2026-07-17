import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_state.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/shimmer/product_card_shimmer.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/products_location_disabled.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/products_empty_state.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/products_grid.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_state.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/customer/products/presentation/utils/products_helper.dart';

// Product List View
class ProductsListView extends StatelessWidget {
  final String initialSearchQuery;
  final String initialSelectedSort;
  final RangeValues? initialPriceRange;
  final Set<String> initialSelectedCategories;
  final String? initialSelectedRating;
  final Set<String>? initialSelectedColors;
  final Set<String>? initialSelectedSizes;

  const ProductsListView({
    super.key,
    required this.initialSearchQuery,
    required this.initialSelectedSort,
    this.initialPriceRange,
    required this.initialSelectedCategories,
    this.initialSelectedRating,
    this.initialSelectedColors,
    this.initialSelectedSizes,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerProductsBloc, CustomerProductsState>(
      builder: (context, state) {
        if (state is CustomerProductsInitial ||
            state is CustomerProductsLoading) {
          return const ProductCardShimmer(
            itemCount: 6,
            physics: AlwaysScrollableScrollPhysics(),
          );
        } else if (state is CustomerProductsLocationDisabled) {
          return ProductsLocationDisabled(
            onRefreshLocation: () {
              context.read<CustomerProductsBloc>().add(
                FetchCustomerProducts(
                  initialSearchQuery: initialSearchQuery,
                  initialSelectedSort: initialSelectedSort,
                  initialPriceRange: initialPriceRange,
                  initialSelectedCategories: initialSelectedCategories,
                  initialSelectedRating: initialSelectedRating,
                  initialSelectedColors: initialSelectedColors,
                  initialSelectedSizes: initialSelectedSizes,
                ),
              );
            },
          );
        } else if (state is CustomerProductsError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(fontSize: 14.sp, color: CustomerAppColors.error),
            ),
          );
        } else if (state is CustomerProductsLoaded) {
          final filteredProducts = state.filteredProducts;
          final shopNames = ProductsHelper.createShopNamesMap(state.shops);

          if (filteredProducts.isEmpty) {
            return const ProductsEmptyState();
          }

          return BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, wishlistState) {
              final wishlistedIds = wishlistState is WishlistLoaded
                  ? wishlistState.items.map((i) => i.product.id).toSet()
                  : <String>{};
              // Product Card
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
                      RemoveProductFromWishlist(productId: product.id),
                    );
                    CustomSnackBar.show(
                      context,
                      message: 'Removed from wishlist',
                    );
                  } else {
                    context.read<WishlistBloc>().add(
                      AddProductToWishlist(product: product, shop: shop),
                    );
                    CustomSnackBar.show(context, message: 'Added to wishlist');
                  }
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
