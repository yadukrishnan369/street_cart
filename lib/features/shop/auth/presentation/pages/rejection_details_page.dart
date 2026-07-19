import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/submitted_information_card.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/resubmission_guidance_card.dart';
import 'package:street_cart/features/shop/auth/presentation/widgets/what_should_you_do_section.dart';

// Rejection Details Page
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
        // Page Header
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
                      // Title
                      Text(
                        'Reason for Rejection',
                        style: ShopAppTextStyles.bodyMediumBold.copyWith(
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Rejection Reason
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
            // Submitted Previous Shop Info Card
            SubmittedInformationCard(shop: shop),
            SizedBox(height: 32.h),
            // Resubmission Guidence Card
            const ResubmissionGuidanceCard(),
            SizedBox(height: 32.h),
            // Guidence Points Section
            const WhatShouldYouDoSection(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
