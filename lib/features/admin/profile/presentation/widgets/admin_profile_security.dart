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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFECEFF1),
          width: 0.8,
        ),
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
                  color: isDark
                      ? AdminAppColors.darkTextPrimary
                      : AdminAppColors.textPrimary,
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
                  color: isDark
                      ? AdminAppColors.darkTextSecondary
                      : const Color(0xFF8A8A9E),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                lastLoginStr,
                style: AdminAppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AdminAppColors.darkTextPrimary
                      : AdminAppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(
            color: isDark ? AdminAppColors.darkBorder : const Color(0xFFECEFF1),
          ),
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
                  color: isDark
                      ? AdminAppColors.darkTextSecondary
                      : const Color(0xFF8A8A9E),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                lastLogoutStr,
                style: AdminAppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AdminAppColors.darkTextPrimary
                      : AdminAppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AdminAppColors.successColor.withValues(alpha: 0.15)
                  : const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: AdminAppColors.successColor,
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    color: AdminAppColors.successColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AdminAppColors.successColor,
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
