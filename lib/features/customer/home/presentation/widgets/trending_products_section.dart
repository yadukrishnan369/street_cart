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
import 'package:street_cart/features/customer/home/presentation/utils/home_helper.dart';

// Trending Products Section
class TrendingProductsSection extends StatelessWidget {
  final List<ProductModel> products;
  final List<ShopProfileModel> shops;
  final String selectedCategory;

  const TrendingProductsSection({
    super.key,
    required this.products,
    required this.shops,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (products.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark
                ? CustomerAppColors.darkEmptyErrorBg
                : const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? CustomerAppColors.darkEmptyErrorBorder
                  : const Color(0xFFFDE68A),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                color: isDark
                    ? CustomerAppColors.warning
                    : const Color(0xFFD97706),
                size: 32.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                'No products available',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.warning
                      : const Color(0xFF92400E),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                selectedCategory == 'All'
                    ? 'No products are currently available in your location.'
                    : 'No products found under "$selectedCategory" in your location.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : const Color(0xFFB45309),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final shopNames = {for (final s in shops) s.uid: s.shopName};

    // Filter by selected category
    final filteredProducts = HomeHelper.filterProductsByCategory(
      products: products,
      selectedCategory: selectedCategory,
    );

    if (filteredProducts.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark
                ? CustomerAppColors.darkEmptyErrorBg
                : const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? CustomerAppColors.darkEmptyErrorBorder
                  : const Color(0xFFFDE68A),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.category_outlined,
                color: isDark
                    ? CustomerAppColors.warning
                    : const Color(0xFFD97706),
                size: 32.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                'No matching products',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.warning
                      : const Color(0xFF92400E),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'No products found under "$selectedCategory" in your location.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : const Color(0xFFB45309),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trending near you',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.darkTextPrimary
                      : CustomerAppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerProductsPage(
                        initialSelectedCategories: {selectedCategory},
                      ),
                    ),
                  );
                },
                child: Text(
                  'See all Products',
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Builder(
            builder: (context) {
              final displayProducts = filteredProducts.take(6).toList();
              return BlocBuilder<WishlistBloc, WishlistState>(
                builder: (context, wishlistState) {
                  final wishlistedIds = wishlistState is WishlistLoaded
                      ? wishlistState.items.map((i) => i.product.id).toSet()
                      : <String>{};

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                    ),
                    itemCount: displayProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayProducts[index];
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

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerProductDetailPage(
                                product: product,
                                shop: shop,
                              ),
                            ),
                          );
                        },
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
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 24.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CustomerProductsPage(
                      initialSelectedCategories: {selectedCategory},
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: CustomerAppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'Explore more Product',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
