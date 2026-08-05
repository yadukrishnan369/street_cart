import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Settings Page Shimmer
class AdminSettingsShimmer extends StatelessWidget {
  const AdminSettingsShimmer({super.key});

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

  Widget _card(BuildContext context, {required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
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

  Widget _settingFieldShimmer(BuildContext context, {double labelWidth = 100}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _box(context, width: labelWidth.w, height: 12.h, radius: 3),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: isDark ? AdminAppColors.darkInputBackground : Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ],
    );
  }

  Widget _switchRowShimmer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(context, width: 120.w, height: 13.h, radius: 3),
            SizedBox(height: 6.h),
            _box(context, width: 200.w, height: 11.h, radius: 3),
          ],
        ),
        _box(context, width: 44.w, height: 24.h, radius: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform Business Settings Card
          _card(
            context,
            child: _shimmer(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _box(context, width: 18.w, height: 18.h, radius: 3),
                          SizedBox(width: 8.w),
                          _box(context, width: 180.w, height: 16.h, radius: 4),
                        ],
                      ),
                      _box(context, width: 110.w, height: 38.h, radius: 8),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    color: isDark
                        ? AdminAppColors.darkBorder
                        : const Color(0xFFF0EFF5),
                    height: 1,
                    thickness: 1.2,
                  ),
                  SizedBox(height: 20.h),
                  _settingFieldShimmer(context, labelWidth: 150),
                  SizedBox(height: 24.h),
                  _switchRowShimmer(context),
                  SizedBox(height: 20.h),
                  _switchRowShimmer(context),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Categories Card
          _card(
            context,
            child: _shimmer(
              context,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _box(context, width: 18.w, height: 18.h, radius: 3),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(context, width: 130.w, height: 14.h, radius: 4),
                          SizedBox(height: 6.h),
                          _box(context, width: 180.w, height: 11.h, radius: 3),
                        ],
                      ),
                    ],
                  ),
                  _box(context, width: 100.w, height: 38.h, radius: 8),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Security & Access Settings Card
          _card(
            context,
            child: _shimmer(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _box(context, width: 18.w, height: 18.h, radius: 3),
                      SizedBox(width: 8.w),
                      _box(context, width: 140.w, height: 14.h, radius: 4),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    color: isDark
                        ? AdminAppColors.darkBorder
                        : const Color(0xFFF0EFF5),
                    height: 1,
                    thickness: 1.2,
                  ),
                  SizedBox(height: 20.h),
                  _settingFieldShimmer(context, labelWidth: 110),
                  SizedBox(height: 20.h),
                  _settingFieldShimmer(context, labelWidth: 100),
                  SizedBox(height: 20.h),
                  _settingFieldShimmer(context, labelWidth: 130),
                  SizedBox(height: 24.h),
                  _box(context, width: 150.w, height: 40.h, radius: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
