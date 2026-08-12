import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Reviews Shimmer
class AdminReviewsShimmer extends StatelessWidget {
  const AdminReviewsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCol = isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE2E8F0);
    final highlightCol = isDark
        ? const Color(0xFF3D3D3D)
        : const Color(0xFFF1F5F9);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 40.w : 20.w,
            vertical: 32.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Statistics Cards
              Row(
                children: [
                  _buildStatCardShimmer(context, isWide ? 260.w : 160.w),
                  SizedBox(width: 20.w),
                  _buildStatCardShimmer(context, isWide ? 260.w : 160.w),
                ],
              ),
              SizedBox(height: 32.h),

              // Table list container
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AdminAppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isDark
                        ? AdminAppColors.darkBorder
                        : const Color(0xFFE8E7ED),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar Shimmer
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 16.h,
                      ),
                      child: Shimmer.fromColors(
                        baseColor: baseCol,
                        highlightColor: highlightCol,
                        child: Container(
                          width: isWide ? 380.w : 240.w,
                          height: 44.h,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AdminAppColors.darkInputBackground
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: isDark
                          ? AdminAppColors.darkBorder
                          : const Color(0xFFF0EFF5),
                      height: 1,
                    ),

                    // Table Rows Shimmer
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 16.h,
                      ),
                      child: Shimmer.fromColors(
                        baseColor: baseCol,
                        highlightColor: highlightCol,
                        child: Column(
                          children: List.generate(6, (index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Row(
                                children: [
                                  // Customer Info
                                  Container(
                                    width: 32.r,
                                    height: 32.r,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AdminAppColors.darkInputBackground
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Container(
                                    width: 90.w,
                                    height: 14.h,
                                    color: isDark
                                        ? AdminAppColors.darkInputBackground
                                        : Colors.white,
                                  ),
                                  const Spacer(),

                                  // Product Name
                                  Container(
                                    width: 130.w,
                                    height: 14.h,
                                    color: isDark
                                        ? AdminAppColors.darkInputBackground
                                        : Colors.white,
                                  ),
                                  const Spacer(),

                                  // Rating stars
                                  Row(
                                    children: List.generate(
                                      5,
                                      (_) => Padding(
                                        padding: EdgeInsets.only(right: 2.w),
                                        child: Container(
                                          width: 16.r,
                                          height: 16.r,
                                          decoration: BoxDecoration(
                                            color: isDark
                                                ? AdminAppColors
                                                      .darkInputBackground
                                                : Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),

                                  // Comment
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 160.w,
                                        height: 12.h,
                                        color: isDark
                                            ? AdminAppColors.darkInputBackground
                                            : Colors.white,
                                      ),
                                      SizedBox(height: 6.h),
                                      Container(
                                        width: 100.w,
                                        height: 12.h,
                                        color: isDark
                                            ? AdminAppColors.darkInputBackground
                                            : Colors.white,
                                      ),
                                    ],
                                  ),
                                  const Spacer(),

                                  // Date
                                  Container(
                                    width: 70.w,
                                    height: 14.h,
                                    color: isDark
                                        ? AdminAppColors.darkInputBackground
                                        : Colors.white,
                                  ),
                                  const Spacer(),

                                  // Action
                                  Container(
                                    width: 40.w,
                                    height: 14.h,
                                    color: isDark
                                        ? AdminAppColors.darkInputBackground
                                        : Colors.white,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCardShimmer(BuildContext context, double width) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCol = isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE2E8F0);
    final highlightCol = isDark
        ? const Color(0xFF3D3D3D)
        : const Color(0xFFF1F5F9);

    return Container(
      width: width,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: baseCol,
        highlightColor: highlightCol,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 80.w,
                  height: 12.h,
                  color: isDark
                      ? AdminAppColors.darkInputBackground
                      : Colors.white,
                ),
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AdminAppColors.darkInputBackground
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              width: 60.w,
              height: 24.h,
              color: isDark ? AdminAppColors.darkInputBackground : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
