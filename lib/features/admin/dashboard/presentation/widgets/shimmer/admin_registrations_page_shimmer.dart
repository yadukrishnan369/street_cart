import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Admin Registrations Page Shimmer
class AdminRegistrationsPageShimmer extends StatelessWidget {
  const AdminRegistrationsPageShimmer({super.key});

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

  Widget _tableRow({bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isHeader ? 16.h : 14.h),
      child: Row(
        children: [
          // Shop Name
          Expanded(
            flex: 28,
            child: Row(
              children: [
                if (!isHeader) ...[
                  _box(width: 36.w, height: 36.h, radius: 8),
                  SizedBox(width: 12.w),
                ],
                _box(
                  width: isHeader ? 80.w : 120.w,
                  height: isHeader ? 11.h : 13.h,
                  radius: 3,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          // Category
          Expanded(
            flex: 20,
            child: _box(
              width: isHeader ? 60.w : 90.w,
              height: isHeader ? 11.h : 12.h,
              radius: 3,
            ),
          ),
          SizedBox(width: 10.w),
          // Registered
          Expanded(
            flex: 18,
            child: _box(
              width: isHeader ? 70.w : 100.w,
              height: isHeader ? 11.h : 12.h,
              radius: 3,
            ),
          ),
          SizedBox(width: 10.w),
          // Status
          Expanded(
            flex: 18,
            child: Container(
              width: 80.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          // Actions
          Expanded(
            flex: 12,
            child: _box(
              width: isHeader ? 50.w : 60.w,
              height: isHeader ? 11.h : 13.h,
              radius: 3,
            ),
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
              // Back row
              _shimmer(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _box(width: 16.w, height: 16.h, radius: 3),
                    SizedBox(width: 8.w),
                    _box(width: 110.w, height: 13.h, radius: 3),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Application Queue Container Shimmer
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: const Color(0xFFE8E7ED),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header inside card
                    Padding(
                      padding: EdgeInsets.all(24.w),
                      child: _shimmer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _box(width: 160.w, height: 16.h, radius: 4),
                            _box(width: 180.w, height: 12.h, radius: 4),
                          ],
                        ),
                      ),
                    ),

                    // Table rows
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
