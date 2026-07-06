import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Admin Registration Details Page Shimmer
class AdminRegistrationDetailsShimmer extends StatelessWidget {
  const AdminRegistrationDetailsShimmer({super.key});

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

  Widget _fieldRow({double labelWidth = 70, double valueWidth = 140}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _box(width: labelWidth.w, height: 11.h, radius: 3),
        SizedBox(height: 6.h),
        _box(width: valueWidth.w, height: 14.h, radius: 4),
      ],
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
              // Back row
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

              // Shop Details Header Card Shimmer
              _card(
                padding: EdgeInsets.all(28.w),
                child: _shimmer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _box(width: 180.w, height: 22.h, radius: 5),
                              SizedBox(width: 12.w),
                              _box(width: 65.w, height: 22.h, radius: 4),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          _box(width: 120.w, height: 12.h, radius: 3),
                        ],
                      ),
                      Row(
                        children: [
                          _box(width: 110.w, height: 40.h, radius: 8),
                          SizedBox(width: 12.w),
                          _box(width: 110.w, height: 40.h, radius: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Content Details Section
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          // Basic Identity Card Shimmer
                          _card(
                            child: _shimmer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _box(
                                        width: 18.w,
                                        height: 18.h,
                                        radius: 3,
                                      ),
                                      SizedBox(width: 8.w),
                                      _box(
                                        width: 110.w,
                                        height: 14.h,
                                        radius: 4,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Divider(
                                    color: const Color(0xFFF0EFF5),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 16.h),
                                  _fieldRow(labelWidth: 80, valueWidth: 160),
                                  SizedBox(height: 20.h),
                                  _fieldRow(labelWidth: 60, valueWidth: 140),
                                  SizedBox(height: 20.h),
                                  _fieldRow(labelWidth: 90, valueWidth: 200),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),

                          // Verification Card Shimmer
                          _card(
                            child: _shimmer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _box(
                                        width: 18.w,
                                        height: 18.h,
                                        radius: 3,
                                      ),
                                      SizedBox(width: 8.w),
                                      _box(
                                        width: 130.w,
                                        height: 14.h,
                                        radius: 4,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Divider(
                                    color: const Color(0xFFF0EFF5),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _fieldRow(
                                          labelWidth: 90,
                                          valueWidth: 160,
                                        ),
                                      ),
                                      _box(
                                        width: 80.w,
                                        height: 36.h,
                                        radius: 6,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _fieldRow(
                                          labelWidth: 90,
                                          valueWidth: 160,
                                        ),
                                      ),
                                      _box(
                                        width: 80.w,
                                        height: 36.h,
                                        radius: 6,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 32.w),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Contact Details Card Shimmer
                          _card(
                            child: _shimmer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _box(
                                        width: 18.w,
                                        height: 18.h,
                                        radius: 3,
                                      ),
                                      SizedBox(width: 8.w),
                                      _box(
                                        width: 120.w,
                                        height: 14.h,
                                        radius: 4,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Divider(
                                    color: const Color(0xFFF0EFF5),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 16.h),
                                  _fieldRow(labelWidth: 80, valueWidth: 180),
                                  SizedBox(height: 20.h),
                                  _fieldRow(labelWidth: 70, valueWidth: 140),
                                  SizedBox(height: 20.h),
                                  _fieldRow(labelWidth: 90, valueWidth: 200),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),

                          // Gst Card Shimmer
                          _card(
                            child: _shimmer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _box(
                                        width: 18.w,
                                        height: 18.h,
                                        radius: 3,
                                      ),
                                      SizedBox(width: 8.w),
                                      _box(
                                        width: 90.w,
                                        height: 14.h,
                                        radius: 4,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Divider(
                                    color: const Color(0xFFF0EFF5),
                                    height: 1,
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _fieldRow(
                                          labelWidth: 80,
                                          valueWidth: 150,
                                        ),
                                      ),
                                      _box(
                                        width: 80.w,
                                        height: 36.h,
                                        radius: 6,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    // Basic Identity Card Shimmer
                    _card(
                      child: _shimmer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _box(width: 110.w, height: 14.h, radius: 4),
                            SizedBox(height: 16.h),
                            _fieldRow(labelWidth: 80, valueWidth: 160),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Contact Details Card Shimmer
                    _card(
                      child: _shimmer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _box(width: 120.w, height: 14.h, radius: 4),
                            SizedBox(height: 16.h),
                            _fieldRow(labelWidth: 80, valueWidth: 180),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}
