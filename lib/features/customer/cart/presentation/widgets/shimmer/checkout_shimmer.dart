import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class CheckoutShimmer extends StatelessWidget {
  const CheckoutShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerBase = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final shimmerHigh = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : CustomerAppColors.surface;
    final cardBorder = isDark
        ? CustomerAppColors.darkBorder
        : Colors.grey.withValues(alpha: 0.1);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              bottom: 16.w,
              top: 4.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address Header Shimmer
                Shimmer.fromColors(
                  baseColor: shimmerBase,
                  highlightColor: shimmerHigh,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 130.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      Container(
                        width: 50.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                // Delivery Address Card
                Container(
                  padding: EdgeInsets.all(16.w),
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
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100.w,
                                height: 14.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: 180.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                width: 140.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                // Payment Methods Header Shimmer
                Shimmer.fromColors(
                  baseColor: shimmerBase,
                  highlightColor: shimmerHigh,
                  child: Container(
                    width: 140.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Payment Card 1
                _buildPaymentCardShimmer(context),
                SizedBox(height: 12.h),
                // Payment Card 2
                _buildPaymentCardShimmer(context),
                SizedBox(height: 28.h),
                // Order Summary Header Shimmer
                Shimmer.fromColors(
                  baseColor: shimmerBase,
                  highlightColor: shimmerHigh,
                  child: Container(
                    width: 120.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Order Summary Card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: cardBorder, width: 1),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: shimmerBase,
                    highlightColor: shimmerHigh,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryRowShimmer(),
                        SizedBox(height: 12.h),
                        _buildSummaryRowShimmer(),
                        SizedBox(height: 16.h),
                        const Divider(color: Colors.white),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            Container(
                              width: 80.w,
                              height: 18.h,
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
              ],
            ),
          ),
        ),
        // Bottom Confirm Button
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: cardBg,
            border: Border(top: BorderSide(color: cardBorder, width: 1)),
          ),
          child: SafeArea(
            child: Shimmer.fromColors(
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
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCardShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerBase = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final shimmerHigh = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : CustomerAppColors.surface;
    final cardBorder = isDark
        ? CustomerAppColors.darkBorder
        : Colors.grey.withValues(alpha: 0.1);

    return Container(
      padding: EdgeInsets.all(16.w),
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
            Container(
              width: 24.w,
              height: 24.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: 180.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRowShimmer() {
    return Row(
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
          width: 30.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }
}
