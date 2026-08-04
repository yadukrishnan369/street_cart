import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

// Resubmission Guidence Card
class ResubmissionGuidanceCard extends StatelessWidget {
  const ResubmissionGuidanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ShopAppColors.primary.withValues(alpha: isDark ? 0.15 : 0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ShopAppColors.primary.withValues(alpha: isDark ? 0.3 : 0.15),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: ShopAppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              // Page Title
              Text(
                'Resubmission Guidance',
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Info 1
          _buildGuidanceBullet(
            'Make sure the shop name matches your official documents or signboard.',
            isDark,
          ),
          SizedBox(height: 12.h),
          // Info 2
          _buildGuidanceBullet(
            'Upload clear, high-resolution photos of government-issued owner ID and Business License.',
            isDark,
          ),
          SizedBox(height: 12.h),
          // Info 3
          _buildGuidanceBullet(
            'Double-check your email and phone number for accuracy so we can contact you if needed.',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildGuidanceBullet(String text, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Container(
            height: 6.r,
            width: 6.r,
            decoration: const BoxDecoration(
              color: ShopAppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: ShopAppTextStyles.bodySmall.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
