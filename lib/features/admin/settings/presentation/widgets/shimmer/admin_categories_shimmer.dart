import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Categories Page Shimmer
class AdminCategoriesShimmer extends StatelessWidget {
  const AdminCategoriesShimmer({super.key});

  Widget _shimmer(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE8E7ED),
      highlightColor: isDark
          ? const Color(0xFF3D3D3D)
          : const Color(0xFFF5F4F9),
      child: child,
    );
  }

  Widget _box(
    BuildContext context, {
    required double width,
    required double height,
    double radius = 6,
  }) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark
          ? AdminAppColors.darkSurface
          : Colors.white,
      borderRadius: BorderRadius.circular(radius.r),
    ),
  );

  Widget _categoryItemShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _box(context, width: 36.w, height: 36.h, radius: 8),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(context, width: 120.w, height: 14.h, radius: 4),
                  SizedBox(height: 6.h),
                  _box(context, width: 80.w, height: 11.h, radius: 3),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _box(
                context,
                width: 44.w,
                height: 24.h,
                radius: 12,
              ), // Visibility switch
              SizedBox(width: 16.w),
              _box(context, width: 32.w, height: 32.h, radius: 6), // Edit btn
              SizedBox(width: 12.w),
              _box(context, width: 32.w, height: 32.h, radius: 6), // Delete btn
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          right: 150.w,
          left: 80,
          top: 32.h,
          bottom: 32.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button Row
            _shimmer(
              context,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _box(context, width: 16.w, height: 16.h, radius: 3),
                      SizedBox(width: 8.w),
                      _box(context, width: 55.w, height: 13.h, radius: 3),
                    ],
                  ),
                  _box(context, width: 140.w, height: 12.h, radius: 4),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Tab selectors
            _shimmer(
              context,
              child: Row(
                children: [
                  _box(context, width: 130.w, height: 40.h, radius: 8),
                  SizedBox(width: 12.w),
                  _box(context, width: 130.w, height: 40.h, radius: 8),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Catalog Title & Add button section
            _shimmer(
              context,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(context, width: 160.w, height: 20.h, radius: 4),
                      SizedBox(height: 6.h),
                      _box(context, width: 250.w, height: 12.h, radius: 3),
                    ],
                  ),
                  _box(context, width: 130.w, height: 40.h, radius: 8),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Category Items List Shimmer
            _shimmer(
              context,
              child: Column(
                children: List.generate(
                  4,
                  (i) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: _categoryItemShimmer(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
