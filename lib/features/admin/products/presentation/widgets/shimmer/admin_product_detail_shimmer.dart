import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Admin Product Detail Page Shimmer
class AdminProductDetailShimmer extends StatelessWidget {
  const AdminProductDetailShimmer({super.key});

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
          final isWide = constraints.maxWidth > 700;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              SizedBox(height: 24.h),
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
                              _box(width: 200.w, height: 22.h, radius: 5),
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
                          _box(width: 120.w, height: 40.h, radius: 8),
                          SizedBox(width: 12.w),
                          _box(width: 40.w, height: 40.h, radius: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              if (isWide) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _card(
                        child: _shimmer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _box(
                                width: double.infinity,
                                height: 350.h,
                                radius: 12,
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                children: List.generate(
                                  3,
                                  (_) => Padding(
                                    padding: EdgeInsets.only(right: 12.w),
                                    child: _box(
                                      width: 64.w,
                                      height: 64.h,
                                      radius: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 32.w),
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
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
                                        width: 100.w,
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
                                  SizedBox(height: 16.h),
                                  _fieldRow(labelWidth: 60, valueWidth: 140),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _fieldRow(
                                          labelWidth: 50,
                                          valueWidth: 100,
                                        ),
                                      ),
                                      Expanded(
                                        child: _fieldRow(
                                          labelWidth: 50,
                                          valueWidth: 80,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  _fieldRow(labelWidth: 60, valueWidth: 120),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                _card(
                  child: _shimmer(
                    child: Row(
                      children: List.generate(
                        4,
                        (i) => Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: i < 3 ? 16.w : 0),
                            child: _fieldRow(labelWidth: 60, valueWidth: 80),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                _card(
                  child: _shimmer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(width: 120.w, height: 16.h, radius: 4),
                        SizedBox(height: 16.h),
                        _box(width: double.infinity, height: 12.h, radius: 3),
                        SizedBox(height: 8.h),
                        _box(width: double.infinity, height: 12.h, radius: 3),
                        SizedBox(height: 8.h),
                        _box(width: 250.w, height: 12.h, radius: 3),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                _card(
                  child: _shimmer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(width: double.infinity, height: 260.h, radius: 12),
                        SizedBox(height: 12.h),
                        Row(
                          children: List.generate(
                            3,
                            (_) => Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: _box(width: 48.w, height: 48.h, radius: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                _card(
                  child: _shimmer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(width: 120.w, height: 14.h, radius: 4),
                        SizedBox(height: 16.h),
                        _fieldRow(labelWidth: 80, valueWidth: 160),
                        SizedBox(height: 16.h),
                        _fieldRow(labelWidth: 60, valueWidth: 140),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
