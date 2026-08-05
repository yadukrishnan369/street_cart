import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/constants/admin_constants.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/theme/admin/admin_text_styles.dart';

// Admin Profile Bio Card
class AdminProfileBioCard extends StatelessWidget {
  const AdminProfileBioCard({super.key});

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
          // Title
          Text(
            AdminConstants.bioTitle,
            style: AdminAppTextStyles.heading3.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AdminAppColors.darkTextPrimary
                  : AdminAppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          // Content
          Text(
            AdminConstants.bioContent,
            style: AdminAppTextStyles.bodyMedium.copyWith(
              color: isDark
                  ? AdminAppColors.darkTextSecondary
                  : const Color(0xFF4A4A68),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
