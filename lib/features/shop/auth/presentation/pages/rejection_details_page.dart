import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/presentation/pages/profile_setup_page.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';

class RejectionDetailsPage extends StatelessWidget {
  final ShopProfileModel shop;

  const RejectionDetailsPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ShopAppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ShopAppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Rejection Details',
          style: ShopAppTextStyles.heading4.copyWith(
            color: ShopAppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rejection Reason Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.red.shade200, width: 1.5.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red.shade700,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Reason for Rejection',
                        style: ShopAppTextStyles.bodyMediumBold.copyWith(
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    shop.rejectionReason.isNotEmpty
                        ? shop.rejectionReason
                        : 'No specific reason provided. Please verify all details and documents before resubmitting.',
                    style: ShopAppTextStyles.bodyMedium.copyWith(
                      color: Colors.red.shade900,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Submitted Information Card
            Text('Submitted Information', style: ShopAppTextStyles.heading3),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: ShopAppColors.textSecondary.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    Icons.storefront_outlined,
                    'Shop Name',
                    shop.shopName,
                  ),
                  Divider(
                    height: 24.h,
                    color: ShopAppColors.textSecondary.withOpacity(0.1),
                  ),
                  _buildDetailRow(
                    Icons.person_outline_rounded,
                    'Owner Name',
                    shop.ownerName,
                  ),
                  Divider(
                    height: 24.h,
                    color: ShopAppColors.textSecondary.withOpacity(0.1),
                  ),
                  _buildDetailRow(
                    Icons.mail_outline_rounded,
                    'Email Address',
                    shop.email,
                  ),
                  Divider(
                    height: 24.h,
                    color: ShopAppColors.textSecondary.withOpacity(0.1),
                  ),
                  _buildDetailRow(
                    Icons.category_outlined,
                    'Category',
                    shop.category,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Guidance Info Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: ShopAppColors.primary.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: ShopAppColors.primary.withOpacity(0.15),
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
            ),
            SizedBox(height: 32.h),

            Text('What should you do?', style: ShopAppTextStyles.heading3),
            SizedBox(height: 16.h),
            _buildStepRow(
              icon: Icons.edit_outlined,
              title: 'Correct Information',
              description:
                  'Tap the button below to update your documents or fields matching the feedback.',
            ),
            SizedBox(height: 16.h),
            _buildStepRow(
              icon: Icons.send_outlined,
              title: 'Resubmit Application',
              description:
                  'After editing, save changes to resubmit your profile for review.',
            ),
            SizedBox(height: 48.h),
            PrimaryButton(
              text: 'Correct Details & Resubmit',
              backgroundColor: ShopAppColors.primary,
              textStyle: ShopAppTextStyles.buttonText.copyWith(
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ShopProfileSetupPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: ShopAppColors.textSecondary, size: 20.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: ShopAppTextStyles.bodySmall.copyWith(
                  color: ShopAppColors.textSecondary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value.isNotEmpty ? value : 'Not provided',
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuidanceBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Container(
            width: 6.w,
            height: 6.h,
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
              color: ShopAppColors.textPrimary,
              height: 1.4,
            ),
          ),
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
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: ShopAppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: ShopAppColors.primary, size: 20.sp),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: ShopAppTextStyles.bodyMediumBold),
              SizedBox(height: 4.h),
              Text(description, style: ShopAppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
