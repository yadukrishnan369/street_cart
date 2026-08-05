import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Shop Detail Shimmer
class AdminShopDetailShimmer extends StatelessWidget {
  const AdminShopDetailShimmer({super.key});

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
    bool circle = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkInputBackground : Colors.white,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius.r),
      ),
    );
  }

  // Generic card container
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // label + value field
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

  // Header Card shimmer
  Widget _headerCard(BuildContext context, bool isWide) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _card(
      context,
      padding: EdgeInsets.all(28.w),
      child: _shimmer(
        context,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo box
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AdminAppColors.darkInputBackground
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _box(
                            context,
                            width: 160.w,
                            height: 22.h,
                            radius: 5,
                          ), // shop name
                          SizedBox(width: 12.w),
                          _box(
                            context,
                            width: 65.w,
                            height: 22.h,
                            radius: 4,
                          ), // status badge
                        ],
                      ),
                      SizedBox(height: 6.h),
                      _box(
                        context,
                        width: 100.w,
                        height: 12.h,
                        radius: 3,
                      ), // merchant ID
                      SizedBox(height: 6.h),
                      _box(
                        context,
                        width: 120.w,
                        height: 12.h,
                        radius: 3,
                      ), // category
                      SizedBox(height: 6.h),
                      _box(
                        context,
                        width: 140.w,
                        height: 12.h,
                        radius: 3,
                      ), // joined date
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Action buttons row
            if (isWide)
              Row(
                children: List.generate(
                  3,
                  (i) => Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: _box(context, width: 110.w, height: 38.h, radius: 8),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 12.w,
                runSpacing: 10.h,
                children: List.generate(
                  3,
                  (_) => _box(context, width: 100.w, height: 36.h, radius: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Business Details card shimmer
  Widget _businessDetailsCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _card(
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
                _box(context, width: 130.w, height: 14.h, radius: 4),
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
                  child: _fieldRow(context, labelWidth: 60, valueWidth: 120),
                ),
                Expanded(
                  child: _fieldRow(context, labelWidth: 60, valueWidth: 120),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _fieldRow(context, labelWidth: 70, valueWidth: 180),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: _fieldRow(context, labelWidth: 60, valueWidth: 90),
                ),
                Expanded(
                  child: _fieldRow(context, labelWidth: 60, valueWidth: 90),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            _fieldRow(context, labelWidth: 55, valueWidth: 150),
            SizedBox(height: 20.h),
            // Payment methods chips
            Row(
              children: List.generate(
                3,
                (i) => Container(
                  margin: EdgeInsets.only(right: 10.w),
                  width: 75.w,
                  height: 28.h,
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
    );
  }

  // Delivery Radius card shimmer
  Widget _deliveryRadiusCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _card(
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
                _box(context, width: 120.w, height: 14.h, radius: 4),
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
            SizedBox(height: 20.h),
            Center(
              child: _box(context, width: 80.w, height: 80.h, radius: 40),
            ), // circle radius display
            SizedBox(height: 12.h),
            Center(
              child: _box(context, width: 100.w, height: 14.h, radius: 4),
            ),
            SizedBox(height: 6.h),
            Center(
              child: _box(context, width: 70.w, height: 12.h, radius: 3),
            ),
          ],
        ),
      ),
    );
  }

  // Verification card shimmer
  Widget _verificationCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _card(
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
                _box(context, width: 130.w, height: 14.h, radius: 4),
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
            ...List.generate(
              3,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: i < 2 ? 14.h : 0),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AdminAppColors.darkInputBackground
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      _box(context, width: 20.w, height: 20.h, radius: 3),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _box(
                          context,
                          width: 90.w,
                          height: 13.h,
                          radius: 4,
                        ),
                      ),
                      _box(context, width: 55.w, height: 20.h, radius: 4),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Products card shimmer
  Widget _productsCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _card(
      context,
      child: _shimmer(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(context, width: 100.w, height: 16.h, radius: 4),
                _box(context, width: 80.w, height: 36.h, radius: 8),
              ],
            ),
            SizedBox(height: 20.h),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 1.2,
              children: List.generate(
                6,
                (_) => Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AdminAppColors.darkInputBackground
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
      physics: const NeverScrollableScrollPhysics(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Go Back Row
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

              // Header card
              _headerCard(context, isWide),
              SizedBox(height: 32.h),

              // Business + Delivery + Verification
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _businessDetailsCard(context)),
                    SizedBox(width: 24.w),
                    Expanded(flex: 3, child: _deliveryRadiusCard(context)),
                    SizedBox(width: 24.w),
                    Expanded(flex: 3, child: _verificationCard(context)),
                  ],
                )
              else
                Column(
                  children: [
                    _businessDetailsCard(context),
                    SizedBox(height: 24.h),
                    _deliveryRadiusCard(context),
                    SizedBox(height: 24.h),
                    _verificationCard(context),
                  ],
                ),
              SizedBox(height: 32.h),

              // Products card
              _productsCard(context),
            ],
          );
        },
      ),
    );
  }
}
