import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_product_detail_page.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_products_page.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/shared/components/customer_product_card.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_state.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';
import 'package:street_cart/features/customer/home/domain/repositories/i_home_repository.dart';
import 'package:street_cart/features/customer/home/presentation/widgets/products_empty_state.dart';
import 'package:street_cart/core/animation/staggered_animation.dart';

// Trending Products Section
class ProductsSection extends StatelessWidget {
  final HomeData homeData;
  final String selectedCategory;

  const ProductsSection({
    super.key,
    required this.homeData,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final recommended = homeData.getRecommended(selectedCategory);
    final hasMoreRecommended = homeData.hasMoreRecommended(selectedCategory);

    final popular = homeData.getPopular(selectedCategory);
    final hasMorePopular = homeData.hasMorePopular(selectedCategory);

    final trending = homeData.getTrending(selectedCategory);
    final hasMoreTrending = homeData.hasMoreTrending(selectedCategory);

    final newArrivals = homeData.getNewArrivals(selectedCategory);
    final hasMoreNewArrivals = homeData.hasMoreNewArrivals(selectedCategory);

    final bestSellers = homeData.getBestSellers(selectedCategory);
    final hasMoreBestSellers = homeData.hasMoreBestSellers(selectedCategory);

    final hasAnyProducts =
        recommended.isNotEmpty ||
        popular.isNotEmpty ||
        trending.isNotEmpty ||
        newArrivals.isNotEmpty ||
        bestSellers.isNotEmpty;

    if (!hasAnyProducts) {
      return const ProductsEmptyState();
    }

    return Column(
      children: [
        // Recommended for you
        _HorizontalProductSection(
          title: 'Recommended for you',
          products: recommended,
          shops: homeData.allNearbyShops,
          hasMore: hasMoreRecommended,
          onViewAllTap: () {
            Navigator.push(
              context,
              AppPageTransitions.slide(
                const CustomerProductsPage(initialSelectedSort: 'Recommended'),
              ),
            );
          },
        ),

        // Popular products
        _HorizontalProductSection(
          title: 'Popular products',
          products: popular,
          shops: homeData.allNearbyShops,
          hasMore: hasMorePopular,
          onViewAllTap: () {
            Navigator.push(
              context,
              AppPageTransitions.slide(
                const CustomerProductsPage(initialSelectedSort: 'Popularity'),
              ),
            );
          },
        ),

        // Trending Nearby you
        _HorizontalProductSection(
          title: 'Trending Nearby you',
          products: trending,
          shops: homeData.allNearbyShops,
          hasMore: hasMoreTrending,
          onViewAllTap: () {
            Navigator.push(
              context,
              AppPageTransitions.slide(
                const CustomerProductsPage(initialSelectedSort: 'Trending'),
              ),
            );
          },
        ),

        // New arrivals
        _HorizontalProductSection(
          title: 'New arrivals',
          products: newArrivals,
          shops: homeData.allNearbyShops,
          hasMore: hasMoreNewArrivals,
          onViewAllTap: () {
            Navigator.push(
              context,
              AppPageTransitions.slide(
                const CustomerProductsPage(initialSelectedSort: 'Newest'),
              ),
            );
          },
        ),

        // Best sellers
        _HorizontalProductSection(
          title: 'Best sellers',
          products: bestSellers,
          shops: homeData.allNearbyShops,
          hasMore: hasMoreBestSellers,
          onViewAllTap: () {
            Navigator.push(
              context,
              AppPageTransitions.slide(
                const CustomerProductsPage(initialSelectedSort: 'Best Sellers'),
              ),
            );
          },
        ),

        // Explore more products button
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  AppPageTransitions.fade(const CustomerProductsPage()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: CustomerAppColors.primary),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Explore more products',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomerAppColors.primary,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}

// Horizontal Scrolling Product Sections
class _HorizontalProductSection extends StatelessWidget {
  final String title;
  final List<ProductModel> products;
  final List<ShopProfileModel> shops;
  final VoidCallback onViewAllTap;
  final bool hasMore;

  const _HorizontalProductSection({
    required this.title,
    required this.products,
    required this.shops,
    required this.onViewAllTap,
    required this.hasMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    final shopNames = {for (final s in shops) s.uid: s.shopName};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.darkTextPrimary
                      : CustomerAppColors.textPrimary,
                ),
              ),
              if (hasMore)
                GestureDetector(
                  onTap: onViewAllTap,
                  child: Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: CustomerAppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 240.h,
          child: BlocBuilder<WishlistBloc, WishlistState>(
            builder: (context, wishlistState) {
              final wishlistedIds = wishlistState is WishlistLoaded
                  ? wishlistState.items.map((i) => i.product.id).toSet()
                  : <String>{};

              return AppStaggeredAnimation.limiter(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: hasMore ? products.length + 1 : products.length,
                  itemBuilder: (context, index) {
                    Widget itemWidget;

                    if (index == products.length) {
                      // View all card
                      itemWidget = GestureDetector(
                        onTap: onViewAllTap,
                        child: Container(
                          width: 140.w,
                          margin: EdgeInsets.only(
                            right: 8.w,
                            top: 4.h,
                            bottom: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? CustomerAppColors.darkSurface
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: isDark
                                  ? CustomerAppColors.darkBorder
                                  : CustomerAppColors.border,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: CustomerAppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: CustomerAppColors.primary,
                                  size: 24.sp,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'View All',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? CustomerAppColors.darkTextPrimary
                                      : CustomerAppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final product = products[index];
                      final imgUrl = product.images.isNotEmpty
                          ? product.images.first
                          : '';
                      final brand = shopNames[product.shopId] ?? 'Unknown Shop';
                      final price = product.offerPrice != null
                          ? '₹${PriceUtils.formatPrice(product.offerPrice!)}'
                          : '₹${PriceUtils.formatPrice(product.originalPrice)}';

                      final shop = shops.firstWhere(
                        (s) => s.uid == product.shopId,
                        orElse: () => ShopProfileModel(
                          uid: product.shopId,
                          ownerName: '',
                          shopName: brand,
                          email: '',
                          category: '',
                          description: '',
                          gstNumber: '',
                          businessLicenseUrl: '',
                          ownerIdUrl: '',
                          isApproved: true,
                          role: 'shop',
                          isProfileCompleted: true,
                          profileImageUrl: '',
                          phone: '',
                          deliveryRadius: 5.0,
                          fullAddress: 'Address Unknown',
                          landmark: '',
                          city: '',
                          pincode: '',
                          district: '',
                          state: '',
                          paymentMethods: [],
                        ),
                      );

                      final isWishlisted = wishlistedIds.contains(product.id);

                      itemWidget = Container(
                        width: 160.w,
                        margin: EdgeInsets.only(right: 12.w),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              AppPageTransitions.slide(
                                CustomerProductDetailPage(
                                  product: product,
                                  shop: shop,
                                ),
                              ),
                            );
                          },
                          // Product Card
                          child: ProductCard(
                            imageUrl: imgUrl,
                            brand: brand,
                            title: product.name,
                            price: price,
                            originalPrice: product.offerPrice != null
                                ? '₹${PriceUtils.formatPrice(product.originalPrice)}'
                                : null,
                            discountPercentage: product.offerPrice != null
                                ? (((product.originalPrice -
                                                  product.offerPrice!) /
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
                                CustomSnackBar.show(
                                  context,
                                  message: 'Removed from wishlist',
                                );
                              } else {
                                context.read<WishlistBloc>().add(
                                  AddProductToWishlist(
                                    product: product,
                                    shop: shop,
                                  ),
                                );
                                CustomSnackBar.show(
                                  context,
                                  message: 'Added to wishlist',
                                );
                              }
                            },
                            isNew:
                                product.createdAt != null &&
                                DateTime.now()
                                        .difference(product.createdAt!)
                                        .inDays <
                                    7,
                          ),
                        ),
                      );
                    }

                    return AppStaggeredAnimation.staggeredList(
                      index: index,
                      child: itemWidget,
                    );
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
