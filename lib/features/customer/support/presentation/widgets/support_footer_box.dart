import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

// Support Footer Box
class SupportFooterBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  const SupportFooterBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.primary.withValues(alpha: 0.15)
            : const Color(0xFFF3F5FF),
        borderRadius: BorderRadius.circular(24.r),
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
      ),
      child: Column(
        children: [
          // Title
          Text(
            title,
            style: CustomerAppTextStyles.heading2.copyWith(
              fontSize: 18.sp,
              color: isDark
                  ? CustomerAppColors.darkTextPrimary
                  : CustomerAppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          // Subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: CustomerAppTextStyles.body.copyWith(
              color: isDark
                  ? CustomerAppColors.darkTextSecondary
                  : Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            // Button
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomerAppColors.primary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
              ),
              child: Text(
                buttonText,
                style: CustomerAppTextStyles.buttonText.copyWith(
                  fontSize: 15.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
