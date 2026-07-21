import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Admin Orders Page Shimmer
class AdminOrdersPageShimmer extends StatelessWidget {
  const AdminOrdersPageShimmer({super.key});

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
              // Title & Subtitle shimmer
              _shimmer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(width: 140.w, height: 26.h, radius: 6),
                    SizedBox(height: 8.h),
                    _box(width: 320.w, height: 14.h, radius: 4),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // TabBar Shimmer
              _shimmer(
                child: Row(
                  children: List.generate(
                    4,
                    (index) => Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: _box(width: 90.w, height: 38.h, radius: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // Table Card Container Shimmer
              Container(
                width: double.infinity,
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
                    // Search bar
                    Padding(
                      padding: EdgeInsets.all(24.w),
                      child: _shimmer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _box(
                              width: isWide ? 320.w : 200.w,
                              height: 42.h,
                              radius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Table Header Shimmer
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.2),
                        1: FlexColumnWidth(2.2),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(1.2),
                        4: FlexColumnWidth(1.4),
                        5: FlexColumnWidth(1.4),
                        6: FlexColumnWidth(1.0),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF4F5F7),
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE8E7ED),
                                width: 1.5,
                              ),
                            ),
                          ),
                          children: List.generate(
                            7,
                            (index) => Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 16.h,
                              ),
                              child: _shimmer(
                                child: _box(
                                  width: 60.w,
                                  height: 11.h,
                                  radius: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Table Row Shimmers
                        ...List.generate(5, (index) {
                          return TableRow(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFF0EFF5),
                                  width: 1.2,
                                ),
                              ),
                            ),
                            children: [
                              // Order ID
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  child: _box(
                                    width: 50.w,
                                    height: 12.h,
                                    radius: 3,
                                  ),
                                ),
                              ),
                              // Product Name + details
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _box(
                                        width: 120.w,
                                        height: 12.h,
                                        radius: 3,
                                      ),
                                      SizedBox(height: 4.h),
                                      _box(width: 70.w, height: 8.h, radius: 2),
                                    ],
                                  ),
                                ),
                              ),
                              // Customer
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  child: _box(
                                    width: 80.w,
                                    height: 12.h,
                                    radius: 3,
                                  ),
                                ),
                              ),
                              // Amount
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  child: _box(
                                    width: 45.w,
                                    height: 12.h,
                                    radius: 3,
                                  ),
                                ),
                              ),
                              // Status Badge
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  child: _box(
                                    width: 65.w,
                                    height: 24.h,
                                    radius: 100,
                                  ),
                                ),
                              ),
                              // Date
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _box(
                                        width: 60.w,
                                        height: 11.h,
                                        radius: 3,
                                      ),
                                      SizedBox(height: 4.h),
                                      _box(width: 40.w, height: 8.h, radius: 2),
                                    ],
                                  ),
                                ),
                              ),
                              // Action Link
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 20.h,
                                ),
                                child: _shimmer(
                                  child: _box(
                                    width: 35.w,
                                    height: 12.h,
                                    radius: 3,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 24.h),
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
