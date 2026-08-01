import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/shimmer/product_card_shimmer.dart';
import 'banner_shimmer.dart';
import 'category_shimmer.dart';
import 'shop_list_shimmer.dart';

// Home Page Shimmer
class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Home Banner Shimmer
          const BannerShimmer(),
          SizedBox(height: 8.h),

          // Category List Shimmer
          const CategoryShimmer(),
          SizedBox(height: 8.h),

          // Nearby Shops List Shimmer
          const ShopListShimmer(),
          SizedBox(height: 16.h),

          // Products Grid Section Title Shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 150.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Container(
                  width: 100.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Products Grid Shimmer
          ProductCardShimmer(
            itemCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
