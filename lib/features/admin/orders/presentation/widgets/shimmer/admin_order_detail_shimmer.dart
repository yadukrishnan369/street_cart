import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';

// Admin Order Detail Shimmer
class AdminOrderDetailShimmer extends StatelessWidget {
  const AdminOrderDetailShimmer({super.key});

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

  @override
  Widget build(BuildContext context) {
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
              // Back Button Shimmer
              _shimmer(
                context,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _box(context, width: 16.w, height: 16.h, radius: 3),
                    SizedBox(width: 8.w),
                    _box(context, width: 80.w, height: 12.h, radius: 3),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Header Shimmer
              _shimmer(
                context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _box(context, width: 150.w, height: 26.h, radius: 6),
                        SizedBox(width: 12.w),
                        _box(context, width: 70.w, height: 24.h, radius: 100),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    _box(context, width: 200.w, height: 12.h, radius: 4),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Grid Content Shimmer
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildTrackingCardShimmer(context),
                          SizedBox(height: 24.h),
                          _buildProductDetailsCardShimmer(context),
                          SizedBox(height: 24.h),
                          _buildPaymentSummaryCardShimmer(context),
                        ],
                      ),
                    ),
                    SizedBox(width: 24.w),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildCustomerInfoCardShimmer(context),
                          SizedBox(height: 24.h),
                          _buildShopInfoCardShimmer(context),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildTrackingCardShimmer(context),
                    SizedBox(height: 24.h),
                    _buildProductDetailsCardShimmer(context),
                    SizedBox(height: 24.h),
                    _buildPaymentSummaryCardShimmer(context),
                    SizedBox(height: 24.h),
                    _buildCustomerInfoCardShimmer(context),
                    SizedBox(height: 24.h),
                    _buildShopInfoCardShimmer(context),
                    SizedBox(height: 24.h),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  // Tracking details card shimmer
  Widget _buildTrackingCardShimmer(BuildContext context) {
    return _card(
      context,
      child: _shimmer(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 8.w),
                _box(context, width: 100.w, height: 14.h, radius: 4),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(context, width: 42.w, height: 42.h, radius: 21.r),
                _box(context, width: 42.w, height: 42.h, radius: 21.r),
                _box(context, width: 42.w, height: 42.h, radius: 21.r),
                _box(context, width: 42.w, height: 42.h, radius: 21.r),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(context, width: 100.w, height: 11.h, radius: 3.r),
                _box(context, width: 100.w, height: 11.h, radius: 3.r),
                _box(context, width: 100.w, height: 11.h, radius: 3.r),
                _box(context, width: 100.w, height: 11.h, radius: 3.r),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Product details card shimmer
  Widget _buildProductDetailsCardShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _card(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmer(
            context,
            child: Row(
              children: [
                SizedBox(width: 8.w),
                _box(context, width: 120.w, height: 14.h, radius: 4),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index) => Divider(
              height: 24.h,
              color: isDark
                  ? AdminAppColors.darkBorder
                  : const Color(0xFFF0EFF5),
            ),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  _shimmer(
                    context,
                    child: _box(context, width: 60.w, height: 60.h, radius: 8),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _shimmer(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(context, width: 150.w, height: 12.h, radius: 3),
                          SizedBox(height: 4.h),
                          _box(context, width: 80.w, height: 8.h, radius: 2),
                          SizedBox(height: 6.h),
                          _box(context, width: 50.w, height: 11.h, radius: 3),
                        ],
                      ),
                    ),
                  ),
                  _shimmer(
                    context,
                    child: _box(context, width: 50.w, height: 12.h, radius: 3),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Payment summary card shimmer
  Widget _buildPaymentSummaryCardShimmer(BuildContext context) {
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
                _box(context, width: 20.w, height: 20.h, radius: 4),
                SizedBox(width: 8.w),
                _box(context, width: 130.w, height: 14.h, radius: 4),
              ],
            ),
            SizedBox(height: 20.h),
            _rowSpacing(
              _box(context, width: 80.w, height: 12.h, radius: 3),
              _box(context, width: 50.w, height: 12.h, radius: 3),
            ),
            SizedBox(height: 12.h),
            _rowSpacing(
              _box(context, width: 100.w, height: 12.h, radius: 3),
              _box(context, width: 40.w, height: 12.h, radius: 3),
            ),
            SizedBox(height: 12.h),
            _rowSpacing(
              _box(context, width: 90.w, height: 12.h, radius: 3),
              _box(context, width: 45.w, height: 12.h, radius: 3),
            ),
            Divider(
              height: 24.h,
              color: isDark
                  ? AdminAppColors.darkBorder
                  : const Color(0xFFF0EFF5),
            ),
            _rowSpacing(
              _box(context, width: 60.w, height: 14.h, radius: 4),
              _box(context, width: 70.w, height: 14.h, radius: 4),
            ),
          ],
        ),
      ),
    );
  }

  // Customer Info Card Shimmer
  Widget _buildCustomerInfoCardShimmer(BuildContext context) {
    return _card(
      context,
      child: _shimmer(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _box(context, width: 20.w, height: 20.h, radius: 4),
                SizedBox(width: 8.w),
                _box(context, width: 120.w, height: 14.h, radius: 4),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                _box(context, width: 44.w, height: 44.h, radius: 100),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(context, width: 110.w, height: 12.h, radius: 3),
                    SizedBox(height: 4.h),
                    _box(context, width: 130.w, height: 10.h, radius: 3),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _box(context, width: 100.w, height: 11.h, radius: 3),
            SizedBox(height: 4.h),
            _box(context, width: 180.w, height: 11.h, radius: 3),
          ],
        ),
      ),
    );
  }

  // Shop Info Card Shimmer
  Widget _buildShopInfoCardShimmer(BuildContext context) {
    return _card(
      context,
      child: _shimmer(
        context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _box(context, width: 20.w, height: 20.h, radius: 4),
                SizedBox(width: 8.w),
                _box(context, width: 100.w, height: 14.h, radius: 4),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                _box(context, width: 44.w, height: 44.h, radius: 100),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(context, width: 100.w, height: 12.h, radius: 3),
                    SizedBox(height: 4.h),
                    _box(context, width: 120.w, height: 10.h, radius: 3),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _box(context, width: 120.w, height: 11.h, radius: 3),
          ],
        ),
      ),
    );
  }

  Widget _rowSpacing(Widget left, Widget right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [left, right],
    );
  }
}
