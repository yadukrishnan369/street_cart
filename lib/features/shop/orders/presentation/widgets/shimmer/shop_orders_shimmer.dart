import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Shop Orders Shimmer
class ShopOrdersShimmer extends StatelessWidget {
  const ShopOrdersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final containerColor = isDark ? Colors.grey[850]! : Colors.white;

    return ListView.builder(
      itemCount: 4,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? ShopAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image shimmer
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 16.w),

                // Details shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 60.w,
                            height: 12.h,
                            color: containerColor,
                          ),
                          Container(
                            width: 40.w,
                            height: 10.h,
                            color: containerColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        width: 140.w,
                        height: 14.h,
                        color: containerColor,
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: 100.w,
                        height: 12.h,
                        color: containerColor,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50.w,
                            height: 16.h,
                            color: containerColor,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 60.w,
                                height: 12.h,
                                color: containerColor,
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                width: 40.w,
                                height: 18.h,
                                decoration: BoxDecoration(
                                  color: containerColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
