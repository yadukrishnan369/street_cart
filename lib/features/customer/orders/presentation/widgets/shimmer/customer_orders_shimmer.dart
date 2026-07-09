import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomerOrdersShimmer extends StatelessWidget {
  const CustomerOrdersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey[300]!;
    final highlightColor = Colors.grey[100]!;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            // Section Label Shimmer
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                width: 120.w,
                height: 14.h,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),

            // Active Order Card Shimmer
            Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Shimmer.fromColors(
                baseColor: baseColor,
                highlightColor: highlightColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 160.w,
                                height: 16.h,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: 120.w,
                                height: 12.h,
                                color: Colors.white,
                              ),
                              SizedBox(height: 6.h),
                              Container(
                                width: 80.w,
                                height: 12.h,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Container(
                          width: 64.w,
                          height: 64.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Section Label Shimmer
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                width: 140.w,
                height: 14.h,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),

            // History Order Card Shimmers
            ...List.generate(3, (index) {
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  child: Row(
                    children: [
                      Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 150.w,
                              height: 14.h,
                              color: Colors.white,
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              width: 100.w,
                              height: 12.h,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
