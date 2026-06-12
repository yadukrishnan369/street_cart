import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

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
            // Verified badge
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

            // Page Main Title
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

            // Introduction section
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

            // 1. Data Collection container card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 241, 241),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.storage_outlined,
                        color: ShopAppColors.primary,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '1. Data Collection',
                        style: ShopAppTextStyles.bodyMediumBold.copyWith(
                          color: ShopAppColors.primary,
                          fontSize: 15.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'We collect information necessary to operate your digital storefront, including:',
                    style: ShopAppTextStyles.bodyMedium.copyWith(
                      color: ShopAppColors.textSecondary,
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildBulletItem('Business registration details and legal name.'),
                  _buildBulletItem('Contact information (email, phone, business address).'),
                  _buildBulletItem('Payment processing information via secure providers.'),
                  _buildBulletItem('Inventory and sales transaction data.'),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // 2. Use of Information
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

            // 3. Security Measures
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

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 5.r,
            height: 5.r,
            decoration: const BoxDecoration(
              color: ShopAppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: ShopAppTextStyles.bodyMedium.copyWith(
                color: ShopAppColors.textSecondary,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
