import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Shop Shimmer Card
class ShopCardShimmer extends StatelessWidget {
  const ShopCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final blockColor = isDark ? Colors.grey[850]! : Colors.white;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF2D2D2D) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Rating Badge
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 180.h,
                    color: blockColor,
                  ),
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      width: 50.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: blockColor,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Info Area
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Category label
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(height: 16.h, color: blockColor),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 60.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: blockColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // Description text lines
                  Container(
                    width: double.infinity,
                    height: 12.h,
                    color: blockColor,
                  ),
                  SizedBox(height: 6.h),
                  Container(width: 220.w, height: 12.h, color: blockColor),
                  SizedBox(height: 16.h),
                  // Location and Action
                  Row(
                    children: [
                      Container(width: 12.w, height: 12.h, color: blockColor),
                      SizedBox(width: 6.w),
                      Container(width: 100.w, height: 12.h, color: blockColor),
                      const Spacer(),
                      Container(width: 80.w, height: 14.h, color: blockColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
