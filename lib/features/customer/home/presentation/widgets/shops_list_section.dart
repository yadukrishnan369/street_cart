import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/shops/presentation/pages/customer_shops_page.dart';
import 'package:street_cart/features/customer/shops/presentation/pages/shop_details_page.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/shop_image_placeholder.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';
import 'package:street_cart/core/animation/staggered_animation.dart';

// Shops List Section
class ShopsListSection extends StatelessWidget {
  final List<ShopProfileModel> shops;

  const ShopsListSection({super.key, required this.shops});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // Shop Empty State
    if (shops.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark
                ? CustomerAppColors.darkEmptyErrorBg
                : CustomerAppColors.emptyErrorBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? CustomerAppColors.darkEmptyErrorBorder
                  : CustomerAppColors.emptyErrorBorder,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.storefront_outlined,
                color: CustomerAppColors.error,
                size: 32.sp,
              ),
              SizedBox(height: 8.h),
              Text(
                'No shops nearby your location',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomerAppColors.error,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'We currently do not have any registered shops delivering to your location. Try selecting a different location.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: CustomerAppColors.error,
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
                '${shops.length} ${shops.length == 1 ? 'shop' : 'shops'} near by you',
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
                    AppPageTransitions.slide(const CustomerShopsPage()),
                  );
                },
                child: Text(
                  'See all Shops',
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
          height: 90.h,
          child: AppStaggeredAnimation.limiter(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: shops.length,
              itemBuilder: (context, index) {
                return AppStaggeredAnimation.staggeredList(
                  index: index,
                  child: _buildShopCard(context, shops[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShopCard(BuildContext context, ShopProfileModel shop) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            AppPageTransitions.slide(ShopDetailsPage(shop: shop)),
          );
        },
        child: Container(
          width: 280.w,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: isDark
                ? Border.all(color: CustomerAppColors.darkBorder)
                : Border.all(color: CustomerAppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Row(
              children: [
                // Shop Profile Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 74.w,
                    height: 74.h,
                    child: shop.profileImageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: shop.profileImageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const ShopImagePlaceholder(iconSize: 32),
                            errorWidget: (context, url, error) =>
                                const ShopImagePlaceholder(iconSize: 32),
                          )
                        : const ShopImagePlaceholder(iconSize: 32),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Shop name
                      Text(
                        shop.shopName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      // Shop Rating
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: CustomerAppColors.warning,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            shop.rating > 0
                                ? shop.rating.toStringAsFixed(1)
                                : 'New',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          // Shop category
                          Text(
                            '• ${shop.category}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      // Shop Address
                      Text(
                        shop.state.isNotEmpty
                            ? '${shop.city}, ${shop.state}'
                            : shop.city,
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
