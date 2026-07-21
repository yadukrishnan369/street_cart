import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/core/utils/url_launcher_helper.dart';

// Verification Card
class VerificationCard extends StatelessWidget {
  final ShopProfileModel shop;

  const VerificationCard({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              // Title
              Text(
                'Verification',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
            ],
          ),
          Divider(height: 32.h, color: const Color(0xFFF0EFF5)),
          // License Section
          _buildVerificationFileItem(
            context: context,
            title: 'Shop License',
            subtitle: shop.gstNumber.isNotEmpty
                ? 'LCN- *************'
                : 'LCN-PENDING-VERIFICATION',
            fileUrl: shop.businessLicenseUrl,
            icon: Icons.description_outlined,
          ),
          SizedBox(height: 16.h),
          // Owner Identity Section
          _buildVerificationFileItem(
            context: context,
            title: 'Owner Identity',
            subtitle: 'Verified via National ID',
            fileUrl: shop.ownerIdUrl,
            icon: Icons.badge_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationFileItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String fileUrl,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF4EBFF),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AdminAppColors.primaryColor, size: 22.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E1E2F),
                  ),
                ),
                SizedBox(height: 4.h),
                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF8A8A9E),
                  ),
                ),
              ],
            ),
          ),
          // Button for Preview
          TextButton(
            onPressed: () => UrlLauncherHelper.launchURL(context, fileUrl),
            child: Text(
              'CLICK TO PREVIEW',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: AdminAppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
