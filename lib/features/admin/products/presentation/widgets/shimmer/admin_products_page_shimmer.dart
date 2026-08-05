import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Products Page Shimmer
class AdminProductsPageShimmer extends StatelessWidget {
  const AdminProductsPageShimmer({super.key});

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

  Widget _metricCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? AdminAppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
            width: 1.5,
          ),
        ),
        child: _shimmer(
          context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(context, width: 70.w, height: 11.h, radius: 3),
              SizedBox(height: 8.h),
              _box(context, width: 50.w, height: 22.h, radius: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tableRow(BuildContext context, {bool isHeader = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isHeader ? 12.h : 14.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                if (!isHeader) ...[
                  _box(context, width: 32.w, height: 32.h, radius: 6),
                  SizedBox(width: 10.w),
                ],
                _box(
                  context,
                  width: isHeader ? 80.w : 110.w,
                  height: isHeader ? 11.h : 13.h,
                  radius: 3,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _box(
              context,
              width: isHeader ? 50.w : 70.w,
              height: isHeader ? 11.h : 12.h,
              radius: 3,
            ),
          ),
          Expanded(
            flex: 2,
            child: _box(
              context,
              width: isHeader ? 50.w : 60.w,
              height: isHeader ? 11.h : 12.h,
              radius: 3,
            ),
          ),
          Expanded(
            flex: 2,
            child: _box(
              context,
              width: isHeader ? 50.w : 60.w,
              height: isHeader ? 11.h : 12.h,
              radius: 3,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: 65.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: isDark
                    ? AdminAppColors.darkInputBackground
                    : Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: _box(context, width: 24.w, height: 24.h, radius: 4),
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
              if (isWide)
                Row(
                  children: [
                    _metricCard(context),
                    _metricCard(context),
                    _metricCard(context),
                    _metricCard(context),
                  ],
                )
              else
                Column(
                  children: List.generate(
                    4,
                    (i) => Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AdminAppColors.darkSurface
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isDark
                              ? AdminAppColors.darkBorder
                              : const Color(0xFFE8E7ED),
                          width: 1.5,
                        ),
                      ),
                      child: _shimmer(
                        context,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _box(context, width: 80.w, height: 11.h, radius: 3),
                            _box(context, width: 40.w, height: 20.h, radius: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 32.h),
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      child: _shimmer(
                        context,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: isWide ? 320.w : 200.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AdminAppColors.darkInputBackground
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            Row(
                              children: List.generate(
                                2,
                                (i) => Container(
                                  margin: EdgeInsets.only(left: 8.w),
                                  width: 90.w,
                                  height: 36.h,
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AdminAppColors.darkInputBackground
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
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
