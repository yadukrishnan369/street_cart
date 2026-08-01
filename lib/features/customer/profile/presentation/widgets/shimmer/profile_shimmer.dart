import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Profile Shimmer
class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  Widget _buildListTileShimmer(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: CustomerAppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: CustomerAppColors.primary.withValues(alpha: 0.3),
              size: 20.sp,
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 4.h),
                  Container(
                    width: 160.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerBase = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final shimmerHigh = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : CustomerAppColors.surface;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Profile Header Card Shimmer
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Shimmer.fromColors(
              baseColor: shimmerBase,
              highlightColor: shimmerHigh,
              child: Column(
                children: [
                  // Circular Avatar Outer Frame
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                    ),
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Name Line
                  Container(
                    width: 150.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  // Email Line
                  Container(
                    width: 180.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Phone Line
                  Container(
                    width: 130.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Location Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(width: 4.w),
                      Container(
                        width: 110.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  // Edit Profile Button Shape
                  Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),

          // Account Settings Section Shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACCOUNT SETTINGS',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? CustomerAppColors.darkTextSecondary
                        : Colors.grey.shade600,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: shimmerBase,
                    highlightColor: shimmerHigh,
                    child: Column(
                      children: [
                        _buildListTileShimmer(
                          context,
                          icon: Icons.map_outlined,
                          title: 'Saved Addresses',
                          subtitle: 'Manage delivery locations',
                        ),
                        Divider(
                          height: 1,
                          indent: 64.w,
                          color: isDark
                              ? CustomerAppColors.darkBorder
                              : Colors.grey.shade100,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  color: CustomerAppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_none,
                                  color: CustomerAppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Container(
                                width: 90.w,
                                height: 14.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 64.w,
                            right: 16.w,
                            bottom: 16.h,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 100.w,
                                    height: 13.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: true,
                                      onChanged: (val) {},
                                      activeThumbColor: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 130.w,
                                    height: 13.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: false,
                                      onChanged: (val) {},
                                      activeThumbColor: Colors.white,
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
