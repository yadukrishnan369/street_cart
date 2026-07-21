import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Admin Customers Page Shimmer
class AdminCustomersPageShimmer extends StatelessWidget {
  const AdminCustomersPageShimmer({super.key});

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

  // Table row shimmer
  Widget _tableRow({bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isHeader ? 12.h : 14.h),
      child: Row(
        children: [
          // Name with avatar
          Expanded(
            flex: 3,
            child: Row(
              children: [
                if (!isHeader) ...[
                  _box(width: 32.w, height: 32.h, circle: true),
                  SizedBox(width: 10.w),
                ],
                _box(
                  width: isHeader ? 50.w : 90.w,
                  height: isHeader ? 11.h : 13.h,
                  radius: 3,
                ),
              ],
            ),
          ),
          // Email
          Expanded(
            flex: 3,
            child: _box(
              width: isHeader ? 50.w : 120.w,
              height: isHeader ? 11.h : 12.h,
              radius: 3,
            ),
          ),
          // Phone
          Expanded(
            flex: 2,
            child: _box(
              width: isHeader ? 45.w : 90.w,
              height: isHeader ? 11.h : 12.h,
              radius: 3,
            ),
          ),
          // Joined
          Expanded(
            flex: 2,
            child: _box(
              width: isHeader ? 50.w : 80.w,
              height: isHeader ? 11.h : 12.h,
              radius: 3,
            ),
          ),
          // Status badge
          Expanded(
            flex: 2,
            child: Container(
              width: 60.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          // Actions
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
              // Filter chips
              _shimmer(
                child: Row(
                  children: [
                    _box(width: 110.w, height: 36.h, radius: 100),
                    SizedBox(width: 12.w),
                    _box(width: 75.w, height: 36.h, radius: 100),
                    SizedBox(width: 12.w),
                    _box(width: 75.w, height: 36.h, radius: 100),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Customers Table Container
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
                    // search bar + filter status dropdown
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      child: _shimmer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: isWide ? 320.w : 200.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            _box(width: 110.w, height: 40.h, radius: 8),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: const Color(0xFFE8E7ED),
                      height: 1,
                      thickness: 1,
                    ),

                    // Table header
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
                              7,
                              (i) => Column(
                                children: [
                                  _tableRow(),
                                  if (i < 6)
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
