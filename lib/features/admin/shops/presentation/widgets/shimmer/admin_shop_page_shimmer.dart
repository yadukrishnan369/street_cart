import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AdminShopPageShimmer extends StatelessWidget {
  const AdminShopPageShimmer({super.key});

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
    bool circle = false,
  }) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: circle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: circle ? null : BorderRadius.circular(radius.r),
    ),
  );

  // Shop Metric Cards
  Widget _metricCard() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: _shimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(width: 70.w, height: 11.h, radius: 3), // label
              SizedBox(height: 8.h),
              _box(width: 50.w, height: 22.h, radius: 5), // value
            ],
          ),
        ),
      ),
    );
  }

  // Table row shimmer
  Widget _tableRow({bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isHeader ? 12.h : 14.h),
      child: Row(
        children: [
          // Shop name / header label
          Expanded(
            flex: 3,
            child: Row(
              children: [
                if (!isHeader) ...[
                  _box(width: 32.w, height: 32.h, radius: 6),
                  SizedBox(width: 10.w),
                ],
                _box(
                  width: isHeader ? 60.w : 100.w,
                  height: isHeader ? 11.h : 13.h,
                  radius: 3,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _box(
              width: isHeader ? 50.w : 80.w,
              height: isHeader ? 11.h : 12.h,
              radius: 3,
            ),
          ),
          Expanded(
            flex: 2,
            child: _box(
              width: isHeader ? 50.w : 70.w,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          // Actions column
          Expanded(
            flex: 1,
            child: _box(width: 24.w, height: 24.h, radius: 4),
          ),
        ],
      ),
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
              // metric cards
              if (isWide)
                Row(children: [_metricCard(), _metricCard(), _metricCard()])
              else
                Column(
                  children: List.generate(
                    3,
                    (i) => Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFFE8E7ED),
                          width: 1.5,
                        ),
                      ),
                      child: _shimmer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _box(width: 80.w, height: 11.h, radius: 3),
                            _box(width: 40.w, height: 20.h, radius: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 32.h),

              // Shops Table Container
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE8E7ED),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // search bar + filter dropdown
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      child: _shimmer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Search bar
                            Container(
                              width: isWide ? 320.w : 200.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            // Filter chips
                            Row(
                              children: List.generate(
                                2,
                                (i) => Container(
                                  margin: EdgeInsets.only(left: 8.w),
                                  width: 80.w,
                                  height: 36.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                      color: const Color(0xFFE8E7ED),
                      height: 1,
                      thickness: 1,
                    ),

                    // Table header + rows
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: _shimmer(
                        child: Column(
                          children: [
                            _tableRow(isHeader: true),
                            Divider(
                              color: const Color(0xFFE8E7ED),
                              height: 1,
                              thickness: 1.5,
                            ),
                            ...List.generate(
                              6,
                              (i) => Column(
                                children: [
                                  _tableRow(),
                                  if (i < 5)
                                    Divider(
                                      color: const Color(0xFFE8E7ED),
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
                      color: const Color(0xFFE8E7ED),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _box(width: 100.w, height: 12.h, radius: 4),
                            Row(
                              children: List.generate(
                                4,
                                (i) => Container(
                                  margin: EdgeInsets.only(left: 6.w),
                                  width: 32.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
