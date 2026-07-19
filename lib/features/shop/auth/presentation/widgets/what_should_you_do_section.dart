import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/profile_setup_page.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

// Guidence Info Section
class WhatShouldYouDoSection extends StatelessWidget {
  const WhatShouldYouDoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What should you do?', style: ShopAppTextStyles.heading3),
        SizedBox(height: 16.h),
        // Guidence info 1
        _buildStepRow(
          icon: Icons.edit_outlined,
          title: 'Correct Information',
          description:
              'Tap the button below to update your documents or fields matching the feedback.',
        ),
        SizedBox(height: 16.h),
        // Guidence info 2
        _buildStepRow(
          icon: Icons.send_outlined,
          title: 'Resubmit Application',
          description:
              'After editing, save changes to resubmit your profile for review.',
        ),
        SizedBox(height: 48.h),
        // Primary Button for Submit Details Again
        PrimaryButton(
          text: 'Correct Details & Resubmit',
          backgroundColor: ShopAppColors.primary,
          textStyle: ShopAppTextStyles.buttonText.copyWith(color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ShopProfileSetupPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStepRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: ShopAppColors.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: ShopAppColors.primary, size: 22.sp),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: ShopAppTextStyles.bodyMediumBold),
              SizedBox(height: 4.h),
              Text(
                description,
                style: ShopAppTextStyles.bodySmall.copyWith(
                  color: ShopAppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
