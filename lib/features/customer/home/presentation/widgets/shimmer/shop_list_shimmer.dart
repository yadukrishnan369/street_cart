import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Shop List Shimmer
class ShopListShimmer extends StatelessWidget {
  const ShopListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final blockColor = isDark ? Colors.grey[850]! : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120.w,
                height: 18.h,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              Container(
                width: 70.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: List.generate(3, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Container(
                    width: 280.w,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: blockColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 74.w,
                          height: 74.h,
                          decoration: BoxDecoration(
                            color: blockColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120.w,
                                height: 14.h,
                                color: blockColor,
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Container(
                                    width: 30.w,
                                    height: 12.h,
                                    color: blockColor,
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    width: 50.w,
                                    height: 12.h,
                                    color: blockColor,
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                width: 80.w,
                                height: 12.h,
                                color: blockColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
