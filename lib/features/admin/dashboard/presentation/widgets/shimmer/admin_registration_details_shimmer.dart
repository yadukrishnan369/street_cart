import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Registration Details Page Shimmer
class AdminRegistrationDetailsShimmer extends StatelessWidget {
  const AdminRegistrationDetailsShimmer({super.key});

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

  Widget _card(
    BuildContext context, {
    required Widget child,
    EdgeInsets? padding,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }

  Widget _fieldRow(
    BuildContext context, {
    double labelWidth = 70,
    double valueWidth = 140,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _box(context, width: labelWidth.w, height: 11.h, radius: 3),
        SizedBox(height: 6.h),
        _box(context, width: valueWidth.w, height: 14.h, radius: 4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
      physics: const NeverScrollableScrollPhysics(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          return Column(
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
                    _box(context, width: 55.w, height: 13.h, radius: 3),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Shop Details Header Card Shimmer
              _card(
                context,
                padding: EdgeInsets.all(28.w),
                child: _shimmer(
                  context,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _box(
                                context,
                                width: 180.w,
                                height: 22.h,
                                radius: 5,
                              ),
                              SizedBox(width: 12.w),
                              _box(
                                context,
                                width: 65.w,
                                height: 22.h,
                                radius: 4,
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          _box(context, width: 120.w, height: 12.h, radius: 3),
                        ],
                      ),
                      Row(
                        children: [
                          _box(context, width: 110.w, height: 40.h, radius: 8),
                          SizedBox(width: 12.w),
                          _box(context, width: 110.w, height: 40.h, radius: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Content Details Section
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          // Basic Identity Card Shimmer
                          _card(
                            context,
                            child: _shimmer(
                              context,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _box(
                                        context,
                                        width: 18.w,
                                        height: 18.h,
                                        radius: 3,
                                      ),
                                      SizedBox(width: 8.w),
                                      _box(
                                        context,
                                        width: 110.w,
                                        height: 14.h,
                                        radius: 4,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Divider(
                                    color: isDark
                                        ? AdminAppColors.darkBorder
                                        : const Color(0xFFF0EFF5),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 16.h),
                                  _fieldRow(
                                    context,
                                    labelWidth: 80,
                                    valueWidth: 160,
                                  ),
                                  SizedBox(height: 20.h),
                                  _fieldRow(
                                    context,
                                    labelWidth: 60,
                                    valueWidth: 140,
                                  ),
                                  SizedBox(height: 20.h),
                                  _fieldRow(
                                    context,
                                    labelWidth: 90,
                                    valueWidth: 200,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),

                          // Verification Card Shimmer
                          _card(
                            context,
                            child: _shimmer(
                              context,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _box(
                                        context,
                                        width: 18.w,
                                        height: 18.h,
                                        radius: 3,
                                      ),
                                      SizedBox(width: 8.w),
                                      _box(
                                        context,
                                        width: 130.w,
                                        height: 14.h,
                                        radius: 4,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Divider(
                                    color: isDark
                                        ? AdminAppColors.darkBorder
                                        : const Color(0xFFF0EFF5),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _fieldRow(
                                          context,
                                          labelWidth: 90,
                                          valueWidth: 160,
                                        ),
                                      ),
                                      _box(
                                        context,
                                        width: 80.w,
                                        height: 36.h,
                                        radius: 6,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _fieldRow(
                                          context,
                                          labelWidth: 90,
                                          valueWidth: 160,
                                        ),
                                      ),
                                      _box(
                                        context,
                                        width: 80.w,
                                        height: 36.h,
                                        radius: 6,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 32.w),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Contact Details Card Shimmer
                          _card(
                            context,
                            child: _shimmer(
                              context,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _box(
                                        context,
                                        width: 18.w,
                                        height: 18.h,
                                        radius: 3,
                                      ),
                                      SizedBox(width: 8.w),
                                      _box(
                                        context,
                                        width: 120.w,
                                        height: 14.h,
                                        radius: 4,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Divider(
                                    color: isDark
                                        ? AdminAppColors.darkBorder
                                        : const Color(0xFFF0EFF5),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 16.h),
                                  _fieldRow(
                                    context,
                                    labelWidth: 80,
                                    valueWidth: 180,
                                  ),
                                  SizedBox(height: 20.h),
                                  _fieldRow(
                                    context,
                                    labelWidth: 70,
                                    valueWidth: 140,
                                  ),
                                  SizedBox(height: 20.h),
                                  _fieldRow(
                                    context,
                                    labelWidth: 90,
                                    valueWidth: 200,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),

                          // Gst Card Shimmer
                          _card(
                            context,
                            child: _shimmer(
                              context,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _box(
                                        context,
                                        width: 18.w,
                                        height: 18.h,
                                        radius: 3,
                                      ),
                                      SizedBox(width: 8.w),
                                      _box(
                                        context,
                                        width: 90.w,
                                        height: 14.h,
                                        radius: 4,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Divider(
                                    color: isDark
                                        ? AdminAppColors.darkBorder
                                        : const Color(0xFFF0EFF5),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _fieldRow(
                                          context,
                                          labelWidth: 80,
                                          valueWidth: 150,
                                        ),
                                      ),
                                      _box(
                                        context,
                                        width: 80.w,
                                        height: 36.h,
                                        radius: 6,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    // Basic Identity Card Shimmer
                    _card(
                      context,
                      child: _shimmer(
                        context,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _box(
                              context,
                              width: 110.w,
                              height: 14.h,
                              radius: 4,
                            ),
                            SizedBox(height: 16.h),
                            _fieldRow(context, labelWidth: 80, valueWidth: 160),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Contact Details Card Shimmer
                    _card(
                      context,
                      child: _shimmer(
                        context,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _box(
                              context,
                              width: 120.w,
                              height: 14.h,
                              radius: 4,
                            ),
                            SizedBox(height: 16.h),
                            _fieldRow(context, labelWidth: 80, valueWidth: 180),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
