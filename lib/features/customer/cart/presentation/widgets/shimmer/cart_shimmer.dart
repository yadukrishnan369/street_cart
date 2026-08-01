import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CartShimmer extends StatelessWidget {
  const CartShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerBase = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final shimmerHigh = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final cardBorder = isDark
        ? const Color(0xFF2D2D2D)
        : Colors.grey.withValues(alpha: 0.1);
    final bottomBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final bottomBorder = isDark
        ? const Color(0xFF2D2D2D)
        : Colors.grey.withValues(alpha: 0.1);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: cardBorder, width: 1),
                ),
                child: Shimmer.fromColors(
                  baseColor: shimmerBase,
                  highlightColor: shimmerHigh,
                  child: Row(
                    children: [
                      // Product Image Shimmer
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Product Details Shimmer
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 140.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              width: 80.w,
                              height: 12.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 60.w,
                                  height: 16.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                                // Quantity selector shimmer
                                Container(
                                  width: 70.w,
                                  height: 24.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Bottom details shimmer
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: bottomBg,
            border: Border(top: BorderSide(color: bottomBorder, width: 1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Order Summary Shimmer Card
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: cardBorder, width: 1),
                ),
                child: Shimmer.fromColors(
                  baseColor: shimmerBase,
                  highlightColor: shimmerHigh,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 80.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          Container(
                            width: 30.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 90.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          Container(
                            width: 40.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      const Divider(color: Colors.white),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          Container(
                            width: 60.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Proceed button shimmer
              Shimmer.fromColors(
                baseColor: shimmerBase,
                highlightColor: shimmerHigh,
                child: Container(
                  width: double.infinity,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
