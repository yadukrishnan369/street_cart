import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class ResubmissionGuidanceCard extends StatelessWidget {
  const ResubmissionGuidanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ShopAppColors.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ShopAppColors.primary.withAlpha(38),
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
              Text(
                'Resubmission Guidance',
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildGuidanceBullet(
            'Make sure the shop name matches your official documents or signboard.',
          ),
          SizedBox(height: 12.h),
          _buildGuidanceBullet(
            'Upload clear, high-resolution photos of government-issued owner ID and Business License.',
          ),
          SizedBox(height: 12.h),
          _buildGuidanceBullet(
            'Double-check your email and phone number for accuracy so we can contact you if needed.',
          ),
        ],
      ),
    );
  }

  Widget _buildGuidanceBullet(String text) {
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
              color: ShopAppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
