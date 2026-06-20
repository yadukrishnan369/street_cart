import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/url_launcher_helper.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class AdminShopVerificationCard extends StatelessWidget {
  final ShopProfileModel shop;

  const AdminShopVerificationCard({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: AdminAppColors.primaryColor,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Verification',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AdminAppColors.textPrimary,
                ),
              ),
            ],
          ),
          Divider(height: 32.h, color: const Color(0xFFF0EFF5), thickness: 1.2),

          // Shop License Document Card
          _buildDocCard(
            context: context,
            icon: Icons.assignment_outlined,
            title: 'Shop License',
            subtitle: shop.gstNumber.isNotEmpty
                ? 'LCN-${shop.gstNumber}'
                : 'LCN-2023-44120',
            onTap: () =>
                UrlLauncherHelper.launchURL(context, shop.businessLicenseUrl),
          ),
          SizedBox(height: 16.h),

          // Owner Identity Document Card
          _buildDocCard(
            context: context,
            icon: Icons.badge_outlined,
            title: 'Owner Identity',
            subtitle: 'Verified via National ID',
            onTap: () => UrlLauncherHelper.launchURL(context, shop.ownerIdUrl),
          ),
        ],
      ),
    );
  }

  Widget _buildDocCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AdminAppColors.primaryColor, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AdminAppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF8A8A9E),
                  ),
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: onTap,
                  child: Text(
                    'CLICK TO PREVIEW',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: AdminAppColors.primaryColor,
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
