import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_product_detail_page.dart';
import 'package:street_cart/features/customer/shops/presentation/bloc/shop_details_bloc.dart';
import 'package:street_cart/features/customer/shops/presentation/bloc/shop_details_state.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/shared/components/customer_product_card.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_state.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class ShopProductsGrid extends StatelessWidget {
  final ShopProfileModel shop;

  const ShopProductsGrid({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopDetailsBloc, ShopDetailsState>(
      builder: (context, state) {
        if (state is ShopDetailsLoading) {
          return SizedBox(
            height: 200.h,
            child: const Center(
              child: CircularProgressIndicator(
                color: CustomerAppColors.primary,
              ),
            ),
          );
        }

        if (state is ShopDetailsError) {
          return SizedBox(
            height: 200.h,
            child: Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: CustomerAppColors.error,
                  fontSize: 14.sp,
                ),
              ),
            ),
          );
        }

        if (state is ShopDetailsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return SizedBox(
              height: 200.h,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 48.sp,
                      color: CustomerAppColors.primary,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'No products available in this shop yet.',
                      style: TextStyle(
                        color: CustomerAppColors.primary,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, wishlistState) {
                final wishlistedIds = wishlistState is WishlistLoaded
                    ? wishlistState.items.map((i) => i.product.id).toSet()
                    : <String>{};

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final formattedPrice = product.offerPrice != null
                        ? '₹${PriceUtils.formatPrice(product.offerPrice!)}'
                        : '₹${PriceUtils.formatPrice(product.originalPrice)}';

                    final isWishlisted = wishlistedIds.contains(product.id);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomerProductDetailPage(
                              product: product,
                              shop: shop,
                            ),
                          ),
                        );
                      },
                      child: ProductCard(
                        imageUrl: product.images.isNotEmpty ? product.images.first : '',
                        brand: shop.shopName,
                        title: product.name,
                        price: formattedPrice,
                        originalPrice: product.offerPrice != null
                            ? '₹${PriceUtils.formatPrice(product.originalPrice)}'
                            : null,
                        discountPercentage: product.offerPrice != null
                            ? (((product.originalPrice - product.offerPrice!) /
                                        product.originalPrice) *
                                    100)
                                .round()
                            : null,
                        isFavorite: isWishlisted,
                        onFavoriteTap: () {
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
                        isNew: product.createdAt != null &&
                            DateTime.now().difference(product.createdAt!).inDays < 7,
                      ),
                    );
                  },
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
