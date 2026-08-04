import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Shop Profile Shimmer
class ShopProfileShimmer extends StatelessWidget {
  const ShopProfileShimmer({super.key});

  // Shimmer placeholder box
  Widget _box({
    required BuildContext context,
    required double width,
    required double height,
    double radius = 6,
    bool circle = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : Colors.white,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(radius.r),
      ),
    );
  }

  // inner content in shimmer
  Widget _shimmer({required BuildContext context, required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: child,
    );
  }

  // Section card container
  Widget _sectionBlock({required BuildContext context, required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      color: isDark ? ShopAppColors.darkSurface : Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      child: _shimmer(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(
              context: context,
              width: 90.w,
              height: 11.h,
              radius: 3,
            ), // section title label
            SizedBox(height: 12.h),
            child,
          ],
        ),
      ),
    );
  }

  // Shop Profile Grid Item
  Widget _gridItem({required BuildContext context, double valueWidth = 100}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _box(context: context, width: 65.w, height: 10.h, radius: 3), // label
        SizedBox(height: 5.h),
        _box(
          context: context,
          width: valueWidth.w,
          height: 13.h,
          radius: 4,
        ), // value
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER - Shop Profile Header Card
          Container(
            width: double.infinity,
            color: isDark ? ShopAppColors.darkSurface : Colors.white,
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
            child: Column(
              children: [
                _shimmer(
                  context: context,
                  child: Column(
                    children: [
                      // CircleAvatar + verified badge
                      SizedBox(
                        width: 118.r,
                        height: 118.r,
                        child: Stack(
                          children: [
                            Container(
                              width: 118.r,
                              height: 118.r,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? ShopAppColors.darkSurface
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Positioned(
                              bottom: 2.h,
                              right: 2.w,
                              child: Container(
                                width: 28.w,
                                height: 28.w,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? ShopAppColors.darkSurface
                                      : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Shop name
                      _box(
                        context: context,
                        width: 160.w,
                        height: 18.h,
                        radius: 6,
                      ),
                      SizedBox(height: 6.h),

                      // Category
                      _box(
                        context: context,
                        width: 100.w,
                        height: 13.h,
                        radius: 4,
                      ),
                      SizedBox(height: 10.h),

                      // Location
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _box(
                            context: context,
                            width: 14.w,
                            height: 14.h,
                            circle: true,
                          ),
                          SizedBox(width: 4.w),
                          _box(
                            context: context,
                            width: 140.w,
                            height: 11.h,
                            radius: 4,
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Verified Seller pill
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? ShopAppColors.darkSurface
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _box(
                              context: context,
                              width: 14.w,
                              height: 14.h,
                              circle: true,
                            ),
                            SizedBox(width: 6.w),
                            _box(
                              context: context,
                              width: 80.w,
                              height: 12.h,
                              radius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // OWNER INFO
          _sectionBlock(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _gridItem(context: context, valueWidth: 90),
                    ),
                    Expanded(
                      child: _gridItem(context: context, valueWidth: 90),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _gridItem(context: context, valueWidth: 160),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // SHOP DESCRIPTION
          _sectionBlock(
            context: context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(
                  context: context,
                  width: double.infinity,
                  height: 13.h,
                  radius: 4,
                ),
                SizedBox(height: 7.h),
                _box(context: context, width: 220.w, height: 13.h, radius: 4),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // DELIVERY RADIUS
          Container(
            width: double.infinity,
            color: isDark ? ShopAppColors.darkSurface : Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
            child: _shimmer(
              context: context,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isDark ? ShopAppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    _box(
                      context: context,
                      width: 24.w,
                      height: 24.h,
                      circle: true,
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(
                          context: context,
                          width: 90.w,
                          height: 11.h,
                          radius: 3,
                        ),
                        SizedBox(height: 4.h),
                        _box(
                          context: context,
                          width: 110.w,
                          height: 13.h,
                          radius: 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // PAYMENT METHODS
          _sectionBlock(
            context: context,
            child: Row(
              children: List.generate(3, (i) {
                return Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? ShopAppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _box(
                        context: context,
                        width: 14.w,
                        height: 14.h,
                        circle: true,
                      ),
                      SizedBox(width: 6.w),
                      _box(
                        context: context,
                        width: 50.w,
                        height: 12.h,
                        radius: 3,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
