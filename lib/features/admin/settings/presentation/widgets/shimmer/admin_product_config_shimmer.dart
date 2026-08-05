import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Product Config Shimmer
class AdminProductConfigShimmer extends StatelessWidget {
  const AdminProductConfigShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE8E8E8),
      highlightColor: isDark
          ? const Color(0xFF3D3D3D)
          : const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
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
              // Back button shimmer
              Row(children: [_box(context, 80.w, 16.h)]),
              SizedBox(height: 24.h),

              // Tab selector shimmer
              Container(
                height: 44.h,
                width: 300.w,
                decoration: BoxDecoration(
                  color: isDark ? AdminAppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 32.h),

              // Section header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(context, 180.w, 22.h),
                      SizedBox(height: 6.h),
                      _box(context, 260.w, 14.h),
                    ],
                  ),
                  _box(context, 140.w, 40.h, radius: 10.r),
                ],
              ),
              SizedBox(height: 24.h),

              // Grid of color chips
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: List.generate(12, (i) => _colorChipShimmer(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorChipShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 120.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark
              ? AdminAppColors.darkBorder
              : AdminAppColors.borderLight,
        ),
      ),
    );
  }

  Widget _box(BuildContext context, double w, double h, {double? radius}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 8.r),
      ),
    );
  }
}
