import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// stat grid
class AdminDashboardShimmer extends StatelessWidget {
  const AdminDashboardShimmer({super.key});

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

  // StatCard
  Widget _statCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF0EFF5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 90.w, height: 13.h, radius: 4), // title
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ), // icon bg
              ],
            ),
            SizedBox(height: 12.h),
            _box(width: 60.w, height: 24.h, radius: 5), // value
          ],
        ),
      ),
    );
  }

  // registration list row
  Widget _registrationRow() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF0EFF5), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(width: 130.w, height: 14.h, radius: 4),
                SizedBox(height: 6.h),
                _box(width: 180.w, height: 12.h, radius: 4),
              ],
            ),
          ),
          Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }

  // table data row
  Widget _tableRow({bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isHeader ? 12.h : 16.h),
      child: Row(
        children: [
          Expanded(
            child: _box(
              width: isHeader ? 60.w : 90.w,
              height: isHeader ? 11.h : 13.h,
              radius: 3,
            ),
          ),
          Expanded(
            child: _box(
              width: isHeader ? 60.w : 80.w,
              height: isHeader ? 11.h : 13.h,
              radius: 3,
            ),
          ),
          Expanded(
            child: _box(
              width: isHeader ? 50.w : 60.w,
              height: isHeader ? 11.h : 13.h,
              radius: 3,
            ),
          ),
          Expanded(
            child: Container(
              width: 60.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          Expanded(
            child: _box(
              width: isHeader ? 40.w : 70.w,
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
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // stat grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              final columns = isWide ? 4 : (constraints.maxWidth > 500 ? 2 : 1);
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: columns,
                crossAxisSpacing: 20.w,
                mainAxisSpacing: 20.h,
                childAspectRatio: isWide ? 1.6 : 2.0,
                children: List.generate(4, (_) => _statCard()),
              );
            },
          ),
          SizedBox(height: 32.h),

          // New Registrations Section
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFF0EFF5), width: 1),
            ),
            child: _shimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _box(width: 140.w, height: 16.h, radius: 4),
                      _box(width: 110.w, height: 12.h, radius: 4),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  ...[0, 1, 2].map(
                    (i) => Padding(
                      padding: EdgeInsets.only(bottom: i < 2 ? 12.h : 0),
                      child: _registrationRow(),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: _box(width: 140.w, height: 14.h, radius: 4),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32.h),

          // Recent Orders Table
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFF0EFF5), width: 1),
            ),
            child: _shimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _box(width: 110.w, height: 16.h, radius: 4),
                      _box(width: 55.w, height: 12.h, radius: 4),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    color: const Color(0xFFF0EFF5),
                    height: 1,
                    thickness: 1.5,
                  ),
                  _tableRow(isHeader: true),
                  Divider(
                    color: const Color(0xFFF0EFF5),
                    height: 1,
                    thickness: 1.5,
                  ),
                  ...List.generate(
                    5,
                    (i) => Column(
                      children: [
                        _tableRow(),
                        if (i < 4)
                          Divider(
                            color: const Color(0xFFF0EFF5),
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
        ],
      ),
    );
  }
}
