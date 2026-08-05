import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Review Detail Shimmer
class ReviewDetailShimmer extends StatelessWidget {
  const ReviewDetailShimmer({super.key});

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
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 40.w : 20.w,
            vertical: 32.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button Shimmer
                Shimmer.fromColors(
                  baseColor: baseCol,
                  highlightColor: highlightCol,
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: isDark
                            ? AdminAppColors.darkInputBackground
                            : Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 100.w,
                        height: 16.h,
                        color: isDark
                            ? AdminAppColors.darkInputBackground
                            : Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Content
                isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildDetailsCard(context)),
                          SizedBox(width: 24.w),
                          SizedBox(
                            width: 320.w,
                            child: _buildActionsCard(context),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildDetailsCard(context),
                          SizedBox(height: 24.h),
                          _buildActionsCard(context),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCol = isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE2E8F0);
    final highlightCol = isDark
        ? const Color(0xFF3D3D3D)
        : const Color(0xFFF1F5F9);

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AdminAppColors.darkInputBackground
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150.w,
                        height: 16.h,
                        color: isDark
                            ? AdminAppColors.darkInputBackground
                            : Colors.white,
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 80.w,
                        height: 12.h,
                        color: isDark
                            ? AdminAppColors.darkInputBackground
                            : Colors.white,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 60.w,
                      height: 10.h,
                      color: isDark
                          ? AdminAppColors.darkInputBackground
                          : Colors.white,
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      width: 80.w,
                      height: 14.h,
                      color: isDark
                          ? AdminAppColors.darkInputBackground
                          : Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Divider(
              color: isDark
                  ? AdminAppColors.darkBorder
                  : const Color(0xFFF0EFF5),
              height: 1,
            ),
            SizedBox(height: 20.h),

            // Rating
            Row(
              children: [
                Row(
                  children: List.generate(
                    5,
                    (_) => Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: Container(
                        width: 20.r,
                        height: 20.r,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AdminAppColors.darkInputBackground
                              : Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 40.w,
                  height: 16.h,
                  color: isDark
                      ? AdminAppColors.darkInputBackground
                      : Colors.white,
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Comments
            Container(
              width: double.infinity,
              height: 16.h,
              color: isDark ? AdminAppColors.darkInputBackground : Colors.white,
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              height: 16.h,
              color: isDark ? AdminAppColors.darkInputBackground : Colors.white,
            ),
            SizedBox(height: 8.h),
            Container(
              width: 220.w,
              height: 16.h,
              color: isDark ? AdminAppColors.darkInputBackground : Colors.white,
            ),
            SizedBox(height: 24.h),

            // Images title
            Container(
              width: 120.w,
              height: 12.h,
              color: isDark ? AdminAppColors.darkInputBackground : Colors.white,
            ),
            SizedBox(height: 12.h),
            Row(
              // List of Images
              children: List.generate(4, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AdminAppColors.darkInputBackground
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 24.h),

            // Product / Shop cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AdminAppColors.darkInputBackground
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isDark
                            ? AdminAppColors.darkBorder
                            : const Color(0xFFE8E7ED),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AdminAppColors.darkSurface
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50.w,
                                height: 10.h,
                                color: isDark
                                    ? AdminAppColors.darkSurface
                                    : Colors.white,
                              ),
                              SizedBox(height: 6.h),
                              Container(
                                width: 100.w,
                                height: 12.h,
                                color: isDark
                                    ? AdminAppColors.darkSurface
                                    : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AdminAppColors.darkInputBackground
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isDark
                            ? AdminAppColors.darkBorder
                            : const Color(0xFFE8E7ED),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AdminAppColors.darkSurface
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50.w,
                                height: 10.h,
                                color: isDark
                                    ? AdminAppColors.darkSurface
                                    : Colors.white,
                              ),
                              SizedBox(height: 6.h),
                              Container(
                                width: 100.w,
                                height: 12.h,
                                color: isDark
                                    ? AdminAppColors.darkSurface
                                    : Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseCol = isDark ? const Color(0xFF2D2D2D) : const Color(0xFFE2E8F0);
    final highlightCol = isDark
        ? const Color(0xFF3D3D3D)
        : const Color(0xFFF1F5F9);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
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
            Container(
              width: 120.w,
              height: 16.h,
              color: isDark ? AdminAppColors.darkInputBackground : Colors.white,
            ),
            SizedBox(height: 16.h),
            Divider(
              color: isDark
                  ? AdminAppColors.darkBorder
                  : const Color(0xFFF0EFF5),
              height: 1,
            ),
            SizedBox(height: 20.h),

            // Action Buttons
            Container(
              width: double.infinity,
              height: 54.h,
              decoration: BoxDecoration(
                color: isDark
                    ? AdminAppColors.darkInputBackground
                    : Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              height: 54.h,
              decoration: BoxDecoration(
                color: isDark
                    ? AdminAppColors.darkInputBackground
                    : Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
