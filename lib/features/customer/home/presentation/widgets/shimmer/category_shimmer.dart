import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Category Shimmer
class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Container(
                width: 80.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850]! : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
