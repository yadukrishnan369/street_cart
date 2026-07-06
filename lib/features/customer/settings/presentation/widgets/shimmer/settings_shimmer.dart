import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class SettingsShimmer extends StatelessWidget {
  const SettingsShimmer({super.key});

  Widget _buildSectionHeaderShimmer(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, top: 24.h, bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: CustomerAppColors.textSecondary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTileShimmer({required IconData icon}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: CustomerAppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: CustomerAppColors.primary.withValues(alpha: 0.3),
                size: 18.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 130.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            const Spacer(),
            // Toggle Switch
            Container(
              width: 36.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTileShimmer({required IconData icon, Color? iconColor}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: (iconColor ?? CustomerAppColors.primary).withValues(
                  alpha: 0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: (iconColor ?? CustomerAppColors.primary).withValues(
                  alpha: 0.3,
                ),
                size: 18.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 120.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey.shade300),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeaderShimmer('APP PREFERENCES'),
          _buildSwitchTileShimmer(icon: Icons.nightlight_round),
          _buildSwitchTileShimmer(icon: Icons.location_on_outlined),

          _buildSectionHeaderShimmer('NOTIFICATION SETTINGS'),
          _buildSwitchTileShimmer(icon: Icons.notifications_none_outlined),
          _buildSwitchTileShimmer(icon: Icons.shopping_bag_outlined),

          _buildSectionHeaderShimmer('PRIVACY & SECURITY'),
          _buildActionTileShimmer(icon: Icons.lock_outline),
          _buildActionTileShimmer(
            icon: Icons.delete_outline,
            iconColor: Colors.red,
          ),

          _buildSectionHeaderShimmer('APP SETTINGS'),
          _buildActionTileShimmer(icon: Icons.cleaning_services_outlined),

          40.verticalSpace,
          Center(
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  Container(
                    width: 120.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    width: 80.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
          40.verticalSpace,
        ],
      ),
    );
  }
}
