import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AdminOrderDetailShimmer extends StatelessWidget {
  const AdminOrderDetailShimmer({super.key});

  static const _baseColor = Color(0xFFE8E7ED);
  static const _highlightColor = Color(0xFFF5F4F9);

  Widget _shimmer({required Widget child}) => Shimmer.fromColors(
    baseColor: _baseColor,
    highlightColor: _highlightColor,
    child: child,
  );

  Widget _box({
    required double width,
    required double height,
    double radius = 6,
  }) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius.r),
    ),
  );

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _box(width: 16.w, height: 16.h, radius: 3),
                    SizedBox(width: 8.w),
                    _box(width: 80.w, height: 12.h, radius: 3),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Header Shimmer
              _shimmer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _box(width: 150.w, height: 26.h, radius: 6),
                        SizedBox(width: 12.w),
                        _box(width: 70.w, height: 24.h, radius: 100),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    _box(width: 200.w, height: 12.h, radius: 4),
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
                          _buildTrackingCardShimmer(),
                          SizedBox(height: 24.h),
                          _buildProductDetailsCardShimmer(),
                          SizedBox(height: 24.h),
                          _buildPaymentSummaryCardShimmer(),
                        ],
                      ),
                    ),
                    SizedBox(width: 24.w),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildCustomerInfoCardShimmer(),
                          SizedBox(height: 24.h),
                          _buildShopInfoCardShimmer(),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildTrackingCardShimmer(),
                    SizedBox(height: 24.h),
                    _buildProductDetailsCardShimmer(),
                    SizedBox(height: 24.h),
                    _buildPaymentSummaryCardShimmer(),
                    SizedBox(height: 24.h),
                    _buildCustomerInfoCardShimmer(),
                    SizedBox(height: 24.h),
                    _buildShopInfoCardShimmer(),
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
  Widget _buildTrackingCardShimmer() {
    return _card(
      child: _shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 8.w),
                _box(width: 100.w, height: 14.h, radius: 4),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 42.w, height: 42.h, radius: 21.r),
                _box(width: 42.w, height: 42.h, radius: 21.r),
                _box(width: 42.w, height: 42.h, radius: 21.r),
                _box(width: 42.w, height: 42.h, radius: 21.r),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 100.w, height: 11.h, radius: 3.r),
                _box(width: 100.w, height: 11.h, radius: 3.r),
                _box(width: 100.w, height: 11.h, radius: 3.r),
                _box(width: 100.w, height: 11.h, radius: 3.r),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Product details card shimmer
  Widget _buildProductDetailsCardShimmer() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmer(
            child: Row(
              children: [
                SizedBox(width: 8.w),
                _box(width: 120.w, height: 14.h, radius: 4),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index) =>
                Divider(height: 24.h, color: const Color(0xFFF0EFF5)),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  _shimmer(
                    child: _box(width: 60.w, height: 60.h, radius: 8),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _shimmer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(width: 150.w, height: 12.h, radius: 3),
                          SizedBox(height: 4.h),
                          _box(width: 80.w, height: 8.h, radius: 2),
                          SizedBox(height: 6.h),
                          _box(width: 50.w, height: 11.h, radius: 3),
                        ],
                      ),
                    ),
                  ),
                  _shimmer(
                    child: _box(width: 50.w, height: 12.h, radius: 3),
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
  Widget _buildPaymentSummaryCardShimmer() {
    return _card(
      child: _shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _box(width: 20.w, height: 20.h, radius: 4),
                SizedBox(width: 8.w),
                _box(width: 130.w, height: 14.h, radius: 4),
              ],
            ),
            SizedBox(height: 20.h),
            _rowSpacing(
              _box(width: 80.w, height: 12.h, radius: 3),
              _box(width: 50.w, height: 12.h, radius: 3),
            ),
            SizedBox(height: 12.h),
            _rowSpacing(
              _box(width: 100.w, height: 12.h, radius: 3),
              _box(width: 40.w, height: 12.h, radius: 3),
            ),
            SizedBox(height: 12.h),
            _rowSpacing(
              _box(width: 90.w, height: 12.h, radius: 3),
              _box(width: 45.w, height: 12.h, radius: 3),
            ),
            Divider(height: 24.h, color: const Color(0xFFF0EFF5)),
            _rowSpacing(
              _box(width: 60.w, height: 14.h, radius: 4),
              _box(width: 70.w, height: 14.h, radius: 4),
            ),
          ],
        ),
      ),
    );
  }

  // Customer Info Card Shimmer
  Widget _buildCustomerInfoCardShimmer() {
    return _card(
      child: _shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _box(width: 20.w, height: 20.h, radius: 4),
                SizedBox(width: 8.w),
                _box(width: 120.w, height: 14.h, radius: 4),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                _box(width: 44.w, height: 44.h, radius: 100),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(width: 110.w, height: 12.h, radius: 3),
                    SizedBox(height: 4.h),
                    _box(width: 130.w, height: 10.h, radius: 3),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _box(width: 100.w, height: 11.h, radius: 3),
            SizedBox(height: 4.h),
            _box(width: 180.w, height: 11.h, radius: 3),
          ],
        ),
      ),
    );
  }

  // Shop Info Card Shimmer
  Widget _buildShopInfoCardShimmer() {
    return _card(
      child: _shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _box(width: 20.w, height: 20.h, radius: 4),
                SizedBox(width: 8.w),
                _box(width: 100.w, height: 14.h, radius: 4),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                _box(width: 44.w, height: 44.h, radius: 100),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(width: 100.w, height: 12.h, radius: 3),
                    SizedBox(height: 4.h),
                    _box(width: 120.w, height: 10.h, radius: 3),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _box(width: 120.w, height: 11.h, radius: 3),
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
