import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AdminCustomerDetailShimmer extends StatelessWidget {
  const AdminCustomerDetailShimmer({super.key});

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

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // Header Card shimmer
  Widget _headerCard(bool isWide) {
    return _card(
      padding: EdgeInsets.all(28.w),
      child: _shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // CircleAvatar
                _box(width: 80.w, height: 80.h, circle: true),
                SizedBox(width: 24.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _box(
                            width: 150.w,
                            height: 20.h,
                            radius: 5,
                          ), // full name
                          SizedBox(width: 10.w),
                          _box(
                            width: 60.w,
                            height: 20.h,
                            radius: 4,
                          ), // status badge
                        ],
                      ),
                      SizedBox(height: 6.h),
                      _box(
                        width: 110.w,
                        height: 12.h,
                        radius: 3,
                      ), // customer ID
                      SizedBox(height: 6.h),
                      _box(width: 160.w, height: 12.h, radius: 3), // email
                      SizedBox(height: 6.h),
                      _box(
                        width: 130.w,
                        height: 12.h,
                        radius: 3,
                      ), // joined date
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            // Action buttons
            if (isWide)
              Row(
                children: List.generate(
                  2,
                  (i) => Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: _box(width: 110.w, height: 38.h, radius: 8),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 12.w,
                runSpacing: 10.h,
                children: List.generate(
                  2,
                  (_) => _box(width: 100.w, height: 36.h, radius: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Contact Info Card shimmer
  Widget _contactInfoCard() {
    return _card(
      padding: EdgeInsets.all(20.w),
      child: _shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _box(width: 18.w, height: 18.h, radius: 3),
                SizedBox(width: 8.w),
                _box(width: 160.w, height: 14.h, radius: 4),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: const Color(0xFFF0EFF5), height: 1, thickness: 1.2),
            SizedBox(height: 16.h),
            _box(width: 80.w, height: 11.h, radius: 3), // Email Address
            SizedBox(height: 6.h),
            _box(width: 180.w, height: 14.h, radius: 4), // email value
            SizedBox(height: 20.h),
            _box(width: 80.w, height: 11.h, radius: 3), // Phone Number
            SizedBox(height: 6.h),
            _box(width: 120.w, height: 14.h, radius: 4), // phone value
            SizedBox(height: 20.h),
            _box(width: 90.w, height: 11.h, radius: 3), // Primary Address
            SizedBox(height: 6.h),
            _box(width: double.infinity, height: 14.h, radius: 4),
            SizedBox(height: 4.h),
            _box(width: 160.w, height: 14.h, radius: 4),
          ],
        ),
      ),
    );
  }

  // Stats Card shimmer
  Widget _statsCard() {
    return _card(
      padding: EdgeInsets.all(20.w),
      child: _shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _box(width: 18.w, height: 18.h, radius: 3),
                SizedBox(width: 8.w),
                _box(width: 130.w, height: 14.h, radius: 4),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: const Color(0xFFF0EFF5), height: 1, thickness: 1.2),
            SizedBox(height: 16.h),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 2.2,
              children: List.generate(
                4,
                (_) => Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(width: 60.w, height: 11.h, radius: 3),
                      SizedBox(height: 6.h),
                      _box(width: 40.w, height: 18.h, radius: 4),
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

  // Past Orders Card shimmer
  Widget _pastOrdersCard() {
    return _card(
      child: _shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 100.w, height: 16.h, radius: 4),
                _box(width: 60.w, height: 12.h, radius: 4),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: const Color(0xFFF0EFF5), height: 1, thickness: 1.2),
            // Table rows
            ...List.generate(
              5,
              (i) => Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: _box(width: 80.w, height: 13.h, radius: 3),
                        ),
                        Expanded(
                          child: _box(width: 90.w, height: 12.h, radius: 3),
                        ),
                        Expanded(
                          child: _box(width: 60.w, height: 13.h, radius: 3),
                        ),
                        Expanded(
                          child: Container(
                            width: 65.w,
                            height: 22.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _box(width: 70.w, height: 12.h, radius: 3),
                        ),
                      ],
                    ),
                  ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
      physics: const NeverScrollableScrollPhysics(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Go Back Row
              _shimmer(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _box(width: 16.w, height: 16.h, radius: 3),
                    SizedBox(width: 8.w),
                    _box(width: 55.w, height: 13.h, radius: 3),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Header card
              _headerCard(isWide),
              SizedBox(height: 32.h),

              // Contact Info + Stats
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _contactInfoCard()),
                    SizedBox(width: 24.w),
                    Expanded(flex: 5, child: _statsCard()),
                  ],
                )
              else
                Column(
                  children: [
                    _contactInfoCard(),
                    SizedBox(height: 24.h),
                    _statsCard(),
                  ],
                ),
              SizedBox(height: 32.h),

              // Past Orders card
              _pastOrdersCard(),
            ],
          );
        },
      ),
    );
  }
}
