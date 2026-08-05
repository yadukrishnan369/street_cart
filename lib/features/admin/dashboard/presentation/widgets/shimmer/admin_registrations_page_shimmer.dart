import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Registrations Page Shimmer
class AdminRegistrationsPageShimmer extends StatelessWidget {
  const AdminRegistrationsPageShimmer({super.key});

  Widget _shimmer(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E7ED),
      highlightColor: isDark
          ? const Color(0xFF383838)
          : const Color(0xFFF5F4F9),
      child: child,
    );
  }

  Widget _box(
    BuildContext context, {
    required double width,
    required double height,
    double radius = 6,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkInputBackground : Colors.white,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }

  Widget _tableRow(BuildContext context, {bool isHeader = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: isHeader ? 16.h : 14.h),
      child: Row(
        children: [
          // Shop Name
          Expanded(
            flex: 28,
            child: Row(
              children: [
                if (!isHeader) ...[
                  _box(context, width: 36.w, height: 36.h, radius: 8),
                  SizedBox(width: 12.w),
                ],
                _box(
                  context,
                  width: isHeader ? 80.w : 120.w,
                  height: isHeader ? 11.h : 13.h,
                  radius: 3,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          // Category
          Expanded(
            flex: 20,
            child: _box(
              context,
              width: isHeader ? 60.w : 90.w,
              height: isHeader ? 11.h : 12.h,
              radius: 3,
            ),
          ),
          SizedBox(width: 10.w),
          // Registered
          Expanded(
            flex: 18,
            child: _box(
              context,
              width: isHeader ? 70.w : 100.w,
              height: isHeader ? 11.h : 12.h,
              radius: 3,
            ),
          ),
          SizedBox(width: 10.w),
          // Status
          Expanded(
            flex: 18,
            child: Container(
              width: 80.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: isDark ? AdminAppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          // Actions
          Expanded(
            flex: 12,
            child: _box(
              context,
              width: isHeader ? 50.w : 60.w,
              height: isHeader ? 11.h : 13.h,
              radius: 3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 40.w : 20.w,
            vertical: 32.h,
          ),
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back row
              _shimmer(
                context,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _box(context, width: 16.w, height: 16.h, radius: 3),
                    SizedBox(width: 8.w),
                    _box(context, width: 110.w, height: 13.h, radius: 3),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Application Queue Container Shimmer
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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header inside card
                    Padding(
                      padding: EdgeInsets.all(24.w),
                      child: _shimmer(
                        context,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _box(
                              context,
                              width: 160.w,
                              height: 16.h,
                              radius: 4,
                            ),
                            _box(
                              context,
                              width: 180.w,
                              height: 12.h,
                              radius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Table rows
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: _shimmer(
                        context,
                        child: Column(
                          children: [
                            _tableRow(context, isHeader: true),
                            Divider(
                              color: isDark
                                  ? AdminAppColors.darkBorder
                                  : const Color(0xFFE8E7ED),
                              height: 1,
                              thickness: 1.5,
                            ),
                            ...List.generate(
                              6,
                              (i) => Column(
                                children: [
                                  _tableRow(context),
                                  if (i < 5)
                                    Divider(
                                      color: isDark
                                          ? AdminAppColors.darkBorder
                                          : const Color(0xFFE8E7ED),
                                      height: 1,
                                      thickness: 1,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: isDark
                          ? AdminAppColors.darkBorder
                          : const Color(0xFFE8E7ED),
                      height: 1,
                      thickness: 1,
                    ),

                    // Pagination row
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 14.h,
                      ),
                      child: _shimmer(
                        context,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _box(
                              context,
                              width: 100.w,
                              height: 12.h,
                              radius: 4,
                            ),
                            Row(
                              children: List.generate(
                                4,
                                (i) => Container(
                                  margin: EdgeInsets.only(left: 6.w),
                                  width: 32.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AdminAppColors.darkInputBackground
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
}
