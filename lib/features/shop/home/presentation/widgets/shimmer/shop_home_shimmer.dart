import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Shop Home Page Shimmer
class ShopHomePageShimmer extends StatelessWidget {
  const ShopHomePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final containerColor = isDark ? Colors.grey[900]! : Colors.white;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            // Performance Today Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 140.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Container(
                  width: 80.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Performance Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 104.h,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Container(
                    height: 104.h,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Performance Cards
            Container(
              height: 84.h,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(28.r),
              ),
            ),
            SizedBox(height: 20.h),

            // Weekly Sales header
            Container(
              width: 160.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 12.h),

            // Weekly Sales Chart box
            Container(
              height: 180.h,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            SizedBox(height: 20.h),

            // Quick Actions header
            Container(
              width: 110.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 12.h),

            // Quick Actions cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 90.h,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Container(
                    height: 90.h,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Container(
                    height: 90.h,
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Recent Orders Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                Container(
                  width: 60.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Recent Orders list items
            Column(
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  height: 78.h,
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                );
              }),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
