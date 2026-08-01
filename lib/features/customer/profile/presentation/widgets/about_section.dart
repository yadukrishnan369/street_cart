import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/services/app_info_service.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/support/presentation/pages/about_app_page.dart';
import 'package:street_cart/features/customer/support/presentation/pages/privacy_policy_page.dart';
import 'package:street_cart/features/customer/support/presentation/pages/terms_conditions_page.dart';

// About Section
class AboutSection extends StatelessWidget {
  final IAppInfoService _appInfoService = sl<IAppInfoService>();

  AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'ABOUT ${_appInfoService.appName.toUpperCase()}',
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
              color: isDark ? CustomerAppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                // About App
                _buildListTile(context, 'About App', AboutAppPage()),
                Divider(
                  height: 1,
                  indent: 16.w,
                  color: isDark
                      ? CustomerAppColors.darkBorder
                      : Colors.grey.shade100,
                ),
                // Privacy Policy
                _buildListTile(
                  context,
                  'Privacy Policy',
                  const PrivacyPolicyPage(),
                ),
                Divider(
                  height: 1,
                  indent: 16.w,
                  color: isDark
                      ? CustomerAppColors.darkBorder
                      : Colors.grey.shade100,
                ),
                // Terms and Conditions
                _buildListTile(
                  context,
                  'Terms & Conditions',
                  const TermsConditionsPage(),
                ),
                Divider(
                  height: 1,
                  indent: 16.w,
                  color: isDark
                      ? CustomerAppColors.darkBorder
                      : Colors.grey.shade100,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'App Version',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark
                              ? CustomerAppColors.darkTextSecondary
                              : Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        _appInfoService.version,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? CustomerAppColors.darkTextSecondary
                              : Colors.grey.shade500,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, Widget page) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? CustomerAppColors.darkTextPrimary
                    : CustomerAppColors.textPrimary,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
