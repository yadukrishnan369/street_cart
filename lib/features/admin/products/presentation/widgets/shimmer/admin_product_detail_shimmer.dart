import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Product Detail Page Shimmer
class AdminProductDetailShimmer extends StatelessWidget {
  const AdminProductDetailShimmer({super.key});

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
          final isWide = constraints.maxWidth > 700;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 24.h),
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
                                width: 200.w,
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
                          _box(context, width: 120.w, height: 40.h, radius: 8),
                          SizedBox(width: 12.w),
                          _box(context, width: 40.w, height: 40.h, radius: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              if (isWide) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _card(
                        context,
                        child: _shimmer(
                          context,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _box(
                                context,
                                width: double.infinity,
                                height: 350.h,
                                radius: 12,
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                children: List.generate(
                                  3,
                                  (_) => Padding(
                                    padding: EdgeInsets.only(right: 12.w),
                                    child: _box(
                                      context,
                                      width: 64.w,
                                      height: 64.h,
                                      radius: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 32.w),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
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
                                        width: 100.w,
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
                                  SizedBox(height: 16.h),
                                  _fieldRow(
                                    context,
                                    labelWidth: 60,
                                    valueWidth: 140,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _fieldRow(
                                          context,
                                          labelWidth: 50,
                                          valueWidth: 100,
                                        ),
                                      ),
                                      Expanded(
                                        child: _fieldRow(
                                          context,
                                          labelWidth: 50,
                                          valueWidth: 80,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  _fieldRow(
                                    context,
                                    labelWidth: 60,
                                    valueWidth: 120,
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
                SizedBox(height: 32.h),
                _card(
                  context,
                  child: _shimmer(
                    context,
                    child: Row(
                      children: List.generate(
                        4,
                        (i) => Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: i < 3 ? 16.w : 0),
                            child: _fieldRow(
                              context,
                              labelWidth: 60,
                              valueWidth: 80,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                _card(
                  context,
                  child: _shimmer(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(context, width: 120.w, height: 16.h, radius: 4),
                        SizedBox(height: 16.h),
                        _box(
                          context,
                          width: double.infinity,
                          height: 12.h,
                          radius: 3,
                        ),
                        SizedBox(height: 8.h),
                        _box(
                          context,
                          width: double.infinity,
                          height: 12.h,
                          radius: 3,
                        ),
                        SizedBox(height: 8.h),
                        _box(context, width: 250.w, height: 12.h, radius: 3),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                _card(
                  context,
                  child: _shimmer(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(
                          context,
                          width: double.infinity,
                          height: 260.h,
                          radius: 12,
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: List.generate(
                            3,
                            (_) => Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: _box(
                                context,
                                width: 48.w,
                                height: 48.h,
                                radius: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                _card(
                  context,
                  child: _shimmer(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(context, width: 120.w, height: 14.h, radius: 4),
                        SizedBox(height: 16.h),
                        _fieldRow(context, labelWidth: 80, valueWidth: 160),
                        SizedBox(height: 16.h),
                        _fieldRow(context, labelWidth: 60, valueWidth: 140),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
