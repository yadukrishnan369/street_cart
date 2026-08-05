import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Orders Page Shimmer
class AdminOrdersPageShimmer extends StatelessWidget {
  const AdminOrdersPageShimmer({super.key});

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
              // Title & Subtitle shimmer
              _shimmer(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(context, width: 140.w, height: 26.h, radius: 6),
                    SizedBox(height: 8.h),
                    _box(context, width: 320.w, height: 14.h, radius: 4),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // TabBar Shimmer
              _shimmer(
                context,
                child: Row(
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: _box(
                        context,
                        width: 90.w,
                        height: 38.h,
                        radius: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Table Card Container Shimmer
              Container(
                width: double.infinity,
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
                    // Search bar
                    Padding(
                      padding: EdgeInsets.all(24.w),
                      child: _shimmer(
                        context,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _box(
                              context,
                              width: isWide ? 320.w : 200.w,
                              height: 42.h,
                              radius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Table Header Shimmer
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(2.2),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(1.2),
                        4: FlexColumnWidth(1.4),
                        5: FlexColumnWidth(1.4),
                        6: FlexColumnWidth(1.0),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AdminAppColors.darkInputBackground
                                : const Color(0xFFF4F5F7),
                            border: Border(
                              bottom: BorderSide(
                                color: isDark
                                    ? AdminAppColors.darkBorder
                                    : const Color(0xFFE8E7ED),
                                width: 1.5,
                              ),
                            ),
                          ),
                          children: List.generate(
                            7,
                            (index) => Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 16.h,
                              ),
                              child: _shimmer(
                                context,
                                child: _box(
                                  context,
                                  width: 60.w,
                                  height: 11.h,
                                  radius: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Table Row Shimmers
                        ...List.generate(5, (index) {
                          return TableRow(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark
                                      ? AdminAppColors.darkBorder
                                      : const Color(0xFFF0EFF5),
                                  width: 1.2,
                                ),
                              ),
                            ),
                            children: [
                              // Order ID
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  context,
                                  child: _box(
                                    context,
                                    width: 50.w,
                                    height: 12.h,
                                    radius: 3,
                                  ),
                                ),
                              ),
                              // Product Name + details
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  context,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _box(
                                        context,
                                        width: 120.w,
                                        height: 12.h,
                                        radius: 3,
                                      ),
                                      SizedBox(height: 4.h),
                                      _box(
                                        context,
                                        width: 70.w,
                                        height: 8.h,
                                        radius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Customer
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  context,
                                  child: _box(
                                    context,
                                    width: 80.w,
                                    height: 12.h,
                                    radius: 3,
                                  ),
                                ),
                              ),
                              // Amount
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  context,
                                  child: _box(
                                    context,
                                    width: 45.w,
                                    height: 12.h,
                                    radius: 3,
                                  ),
                                ),
                              ),
                              // Status Badge
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  context,
                                  child: _box(
                                    context,
                                    width: 65.w,
                                    height: 24.h,
                                    radius: 100,
                                  ),
                                ),
                              ),
                              // Date
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  context,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _box(
                                        context,
                                        width: 60.w,
                                        height: 11.h,
                                        radius: 3,
                                      ),
                                      SizedBox(height: 4.h),
                                      _box(
                                        context,
                                        width: 40.w,
                                        height: 8.h,
                                        radius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Action Link
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  context,
                                  child: _box(
                                    context,
                                    width: 35.w,
                                    height: 12.h,
                                    radius: 3,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 24.h),
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
