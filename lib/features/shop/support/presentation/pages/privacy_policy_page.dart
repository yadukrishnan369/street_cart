import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/data_collection_card.dart';

// Privacy Policy Page
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: ShopAppColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
        // Page Header
        title: Text(
          'Privacy Policy',
          style: ShopAppTextStyles.heading4.copyWith(
            color: ShopAppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verified Badge Header Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: ShopAppColors.primary,
                    size: 14.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Street Cart Verified',
                    style: ShopAppTextStyles.bodySmallBold.copyWith(
                      color: ShopAppColors.primary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Page Titles
            Text(
              'Shop Owner Privacy Policy',
              style: ShopAppTextStyles.heading2.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Last Updated: October 24, 2023',
              style: ShopAppTextStyles.bodySmall.copyWith(
                color: ShopAppColors.textSecondary,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 24.h),

            // Section 1 - Introduction
            Text(
              'Introduction',
              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                color: ShopAppColors.primary,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'At Street Cart, we are committed to protecting the privacy and security of our merchant partners. This privacy policy outlines how we handle your personal and business data when you use our mobile application and commerce services.',
              style: ShopAppTextStyles.bodyMedium.copyWith(
                color: ShopAppColors.textSecondary,
                height: 1.5,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 24.h),

            // Section 2 - Data Collection Container Card
            const DataCollectionCard(),
            SizedBox(height: 24.h),

            // Section 3 - Use of Information
            Text(
              '2. Use of Information',
              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                color: ShopAppColors.primary,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your data is primarily used to provide and improve Street Cart services. This includes processing orders, calculating analytics for your dashboard, and providing customer support. We never sell your personal data to third-party advertisers.',
              style: ShopAppTextStyles.bodyMedium.copyWith(
                color: ShopAppColors.textSecondary,
                height: 1.5,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 24.h),

            // Section 4 - Security Measures
            Text(
              '3. Security Measures',
              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                color: ShopAppColors.primary,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'We implement industry-standard encryption (AES-256) for all data at rest and in transit. Access to merchant data is strictly limited to authorized personnel only.',
              style: ShopAppTextStyles.bodyMedium.copyWith(
                color: ShopAppColors.textSecondary,
                height: 1.5,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
