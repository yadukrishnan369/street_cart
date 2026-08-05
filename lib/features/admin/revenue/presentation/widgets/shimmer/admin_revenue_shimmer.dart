import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Revenue Shimmer
class AdminRevenueShimmer extends StatelessWidget {
  const AdminRevenueShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title & dropdowns shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerBox(context, 220.w, 28.h, radius: 6.r),
                  SizedBox(height: 10.h),
                  _shimmerBox(context, 340.w, 16.h, radius: 4.r),
                ],
              ),
              Row(
                children: [
                  _shimmerBox(context, 140.w, 44.h, radius: 10.r),
                  SizedBox(width: 16.w),
                  _shimmerBox(context, 140.w, 44.h, radius: 10.r),
                  SizedBox(width: 16.w),
                  _shimmerBox(context, 120.w, 44.h, radius: 10.r),
                  SizedBox(width: 12.w),
                  _shimmerBox(context, 44.w, 44.h, radius: 10.r),
                ],
              ),
            ],
          ),
          SizedBox(height: 32.h),

          // 3 Stat Cards Shimmer
          Row(
            children: List.generate(
              3,
              (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index == 2 ? 0 : 16.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 22.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AdminAppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isDark
                          ? AdminAppColors.darkBorder
                          : const Color(0xFFF0EFF5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _shimmerBox(context, 44.r, 44.r, radius: 10.r),
                      SizedBox(width: 18.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _shimmerBox(context, 90.w, 13.h, radius: 4.r),
                            SizedBox(height: 10.h),
                            _shimmerBox(context, 120.w, 22.h, radius: 6.r),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 36.h),

          // Table Container Shimmer
          Container(
            decoration: BoxDecoration(
              color: isDark ? AdminAppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDark
                    ? AdminAppColors.darkBorder
                    : const Color(0xFFF0EFF5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar area
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 18.h,
                  ),
                  child: _shimmerBox(context, 380.w, 42.h, radius: 10.r),
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AdminAppColors.darkBorder
                      : const Color(0xFFF0EFF5),
                ),

                // Table Header Shimmer
                Container(
                  color: isDark
                      ? AdminAppColors.darkInputBackground
                      : const Color(0xFFF4F5F7),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 16,
                        child: _shimmerBox(context, 70.w, 13.h),
                      ),
                      Expanded(
                        flex: 14,
                        child: _shimmerBox(context, 55.w, 13.h),
                      ),
                      Expanded(
                        flex: 20,
                        child: _shimmerBox(context, 90.w, 13.h),
                      ),
                      Expanded(
                        flex: 20,
                        child: _shimmerBox(context, 80.w, 13.h),
                      ),
                      Expanded(
                        flex: 16,
                        child: _shimmerBox(context, 70.w, 13.h),
                      ),
                      Expanded(
                        flex: 14,
                        child: _shimmerBox(context, 75.w, 13.h),
                      ),
                      Expanded(
                        flex: 10,
                        child: _shimmerBox(context, 45.w, 13.h),
                      ),
                    ],
                  ),
                ),

                // Table Rows Shimmer
                ...List.generate(
                  5,
                  (i) => Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 18.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 16,
                              child: _shimmerBox(
                                context,
                                85.w,
                                14.h,
                                radius: 4.r,
                              ),
                            ),
                            Expanded(
                              flex: 14,
                              child: _shimmerBox(
                                context,
                                80.w,
                                14.h,
                                radius: 4.r,
                              ),
                            ),
                            Expanded(
                              flex: 20,
                              child: _shimmerBox(
                                context,
                                110.w,
                                14.h,
                                radius: 4.r,
                              ),
                            ),
                            Expanded(
                              flex: 20,
                              child: _shimmerBox(
                                context,
                                100.w,
                                14.h,
                                radius: 4.r,
                              ),
                            ),
                            Expanded(
                              flex: 16,
                              child: _shimmerBox(
                                context,
                                70.w,
                                14.h,
                                radius: 4.r,
                              ),
                            ),
                            Expanded(
                              flex: 14,
                              child: _shimmerBox(
                                context,
                                65.w,
                                14.h,
                                radius: 4.r,
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: _shimmerBox(
                                context,
                                40.w,
                                14.h,
                                radius: 4.r,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i < 4)
                        Divider(
                          height: 1,
                          color: isDark
                              ? AdminAppColors.darkBorder
                              : const Color(0xFFF0EFF5),
                        ),
                    ],
                  ),
                ),

                Divider(
                  height: 1,
                  color: isDark
                      ? AdminAppColors.darkBorder
                      : const Color(0xFFF0EFF5),
                ),
                // Pagination Shimmer
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _shimmerBox(context, 36.w, 36.h, radius: 8.r),
                      SizedBox(width: 8.w),
                      ...List.generate(
                        4,
                        (idx) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: _shimmerBox(context, 36.w, 36.h, radius: 8.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _shimmerBox(context, 36.w, 36.h, radius: 8.r),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerBox(
    BuildContext context,
    double width,
    double height, {
    double? radius,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE2E8F0),
      highlightColor: isDark
          ? const Color(0xFF3D3D3D)
          : const Color(0xFFF1F5F9),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? AdminAppColors.darkInputBackground : Colors.white,
          borderRadius: BorderRadius.circular(radius ?? 4.r),
        ),
      ),
    );
  }
}
