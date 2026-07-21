import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';

// Admin Profile Security
class AdminProfileSecurity extends StatelessWidget {
  final String lastLoginStr;
  final String lastLogoutStr;

  const AdminProfileSecurity({
    super.key,
    required this.lastLoginStr,
    required this.lastLogoutStr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security_outlined,
                size: 20.sp,
                color: AdminAppColors.primaryColor,
              ),
              SizedBox(width: 10.w),
              // Title
              Text(
                'Security & Access',
                style: AdminAppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Last Login Time
              Text(
                'LAST LOGIN',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8A8A9E),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                lastLoginStr,
                style: AdminAppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const Divider(color: Color(0xFFECEFF1)),
          SizedBox(height: 16.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Admin Last Logout Time
              Text(
                'LAST LOGOUT',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8A8A9E),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                lastLogoutStr,
                style: AdminAppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E7D32),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
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
