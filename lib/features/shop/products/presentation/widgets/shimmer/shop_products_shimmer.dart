import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Shop Products Shimmer
class ShopProductsShimmer extends StatelessWidget {
  final int itemCount;

  const ShopProductsShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final skeletonColor = isDark ? Colors.grey[700]! : Colors.white;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isDark ? ShopAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Row(
              children: [
                // Product Image
                Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    color: skeletonColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Title
                      Container(
                        width: 150.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Product Price
                      Container(
                        width: 60.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: skeletonColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // Status dot & text & stock quantity
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Container(
                            width: 50.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            width: 60.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: skeletonColor,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Trailing popup menu dots
                Icon(
                  Icons.more_vert,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
