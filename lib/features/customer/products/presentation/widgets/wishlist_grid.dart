import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_event.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_product_detail_page.dart';
import 'package:street_cart/shared/components/customer_product_card.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';
import 'package:street_cart/core/animation/staggered_animation.dart';

// Wish List Grid
class WishlistGrid extends StatelessWidget {
  final List<WishlistItem> items;

  const WishlistGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: Text(
            '${items.length} ${items.length == 1 ? "item" : "items"} saved from your nearby shops',
            style: TextStyle(
              fontSize: 13.sp,
              color: CustomerAppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          // Products Grid View
          child: AppStaggeredAnimation.limiter(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final product = item.product;
                final shop = item.shop;
                final priceText = product.offerPrice != null
                    ? '₹${PriceUtils.formatPrice(product.offerPrice!)}'
                    : '₹${PriceUtils.formatPrice(product.originalPrice)}';

                return AppStaggeredAnimation.staggeredGrid(
                  index: index,
                  columnCount: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        AppPageTransitions.slide(
                          CustomerProductDetailPage(
                            product: product,
                            shop: shop,
                            initialColor: item.selectedColor,
                            initialSize: item.selectedSize,
                          ),
                        ),
                      ).then((_) {
                        if (context.mounted) {
                          context.read<WishlistBloc>().add(LoadWishlist());
                        }
                      });
                    },
                    // Wish List Product Items
                    child: ProductCard(
                      imageUrl: product.images.isNotEmpty
                          ? product.images.first
                          : '',
                      brand: shop.shopName,
                      title: product.name,
                      price: priceText,
                      originalPrice: product.offerPrice != null
                          ? '₹${PriceUtils.formatPrice(product.originalPrice)}'
                          : null,
                      discountPercentage: product.offerPrice != null
                          ? (((product.originalPrice - product.offerPrice!) /
                                        product.originalPrice) *
                                    100)
                                .round()
                          : null,
                      isFavorite: true,
                      onFavoriteTap: () {
                        context.read<WishlistBloc>().add(
                          RemoveProductFromWishlist(productId: product.id),
                        );
                        CustomSnackBar.show(
                          context,
                          message: 'Removed from wishlist',
                        );
                      },
                      isNew:
                          product.createdAt != null &&
                          DateTime.now().difference(product.createdAt!).inDays <
                              7,
                      selectedColor: item.selectedColor,
                      selectedSize: item.selectedSize,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
