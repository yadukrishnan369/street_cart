import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Admin Settings Page Shimmer
class AdminSettingsShimmer extends StatelessWidget {
  const AdminSettingsShimmer({super.key});

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

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: child,
    );
  }

  Widget _settingFieldShimmer({double labelWidth = 100}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _box(width: labelWidth.w, height: 12.h, radius: 3),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ],
    );
  }

  Widget _switchRowShimmer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(width: 120.w, height: 13.h, radius: 3),
            SizedBox(height: 6.h),
            _box(width: 200.w, height: 11.h, radius: 3),
          ],
        ),
        _box(width: 44.w, height: 24.h, radius: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 32.h),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform Business Settings Card
          _card(
            child: _shimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _box(width: 18.w, height: 18.h, radius: 3),
                          SizedBox(width: 8.w),
                          _box(width: 180.w, height: 16.h, radius: 4),
                        ],
                      ),
                      _box(width: 110.w, height: 38.h, radius: 8),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    color: const Color(0xFFF0EFF5),
                    height: 1,
                    thickness: 1.2,
                  ),
                  SizedBox(height: 20.h),
                  _settingFieldShimmer(labelWidth: 150),
                  SizedBox(height: 24.h),
                  _switchRowShimmer(),
                  SizedBox(height: 20.h),
                  _switchRowShimmer(),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Categories Card
          _card(
            child: _shimmer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _box(width: 18.w, height: 18.h, radius: 3),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(width: 130.w, height: 14.h, radius: 4),
                          SizedBox(height: 6.h),
                          _box(width: 180.w, height: 11.h, radius: 3),
                        ],
                      ),
                    ],
                  ),
                  _box(width: 100.w, height: 38.h, radius: 8),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),

          // Security & Access Settings Card
          _card(
            child: _shimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _box(width: 18.w, height: 18.h, radius: 3),
                      SizedBox(width: 8.w),
                      _box(width: 140.w, height: 14.h, radius: 4),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    color: const Color(0xFFF0EFF5),
                    height: 1,
                    thickness: 1.2,
                  ),
                  SizedBox(height: 20.h),
                  _settingFieldShimmer(labelWidth: 110),
                  SizedBox(height: 20.h),
                  _settingFieldShimmer(labelWidth: 100),
                  SizedBox(height: 20.h),
                  _settingFieldShimmer(labelWidth: 130),
                  SizedBox(height: 24.h),
                  _box(width: 150.w, height: 40.h, radius: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
