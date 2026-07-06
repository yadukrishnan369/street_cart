import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

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
          'Terms & Conditions',
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
            // Page Title
            Text(
              'Street Cart Terms of Service',
              style: ShopAppTextStyles.heading3.copyWith(
                color: ShopAppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Last updated: March 03, 2026',
              style: ShopAppTextStyles.bodySmall.copyWith(
                color: ShopAppColors.textSecondary,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 24.h),

            // Acceptance of Terms
            _buildSectionHeader('1. Acceptance of Terms'),
            _buildSectionBody(
              'Welcome to Street Cart. By using our platform to manage your shop, you agree to comply with and be bound by the following terms and conditions of use, which together with our privacy policy govern Street Cart\'s relationship with you.',
            ),

            // Merchant Responsibilities
            _buildSectionHeader('2. Merchant Responsibilities'),
            _buildSectionBody(
              'As a shop owner on Street Cart, you are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
            ),
            SizedBox(height: 8.h),
            _buildBulletItem(
              'You must provide accurate information regarding your business and products.',
            ),
            _buildBulletItem(
              'You are responsible for fulfilling orders in a timely manner.',
            ),
            _buildBulletItem(
              'You must comply with all local tax and business regulations.',
            ),
            SizedBox(height: 12.h),

            // Fees and Payments
            _buildSectionHeader('3. Fees and Payments'),
            _buildSectionBody(
              'Street Cart charges a processing fee on each transaction completed through the platform. These fees are subject to change with a 30-day notice. All payouts are processed within 3-5 business days of order completion.',
            ),

            // Prohibited Content
            _buildSectionHeader('4. Prohibited Content'),
            _buildSectionBody(
              'Users may not list items that are illegal, hazardous, or infringe on the intellectual property rights of others. Street Cart reserves the right to remove any product listing that violates these terms.',
            ),

            // Privacy and Data
            _buildSectionHeader('5. Privacy and Data'),
            _buildSectionBody(
              'We value your privacy. Merchant data is used solely for the purpose of facilitating transactions and improving our service. We do not sell your business data to third parties.',
            ),

            // Limitation of Liability
            _buildSectionHeader('6. Limitation of Liability'),
            _buildSectionBody(
              'Street Cart shall not be liable for any indirect, incidental, special, or consequential damages resulting from the use or inability to use the service.',
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
      child: Text(
        title,
        style: ShopAppTextStyles.bodyMediumBold.copyWith(
          color: ShopAppColors.textPrimary,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionBody(String bodyText) {
    return Text(
      bodyText,
      style: ShopAppTextStyles.bodyMedium.copyWith(
        color: ShopAppColors.textSecondary,
        height: 1.5,
        fontSize: 13.sp,
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
            width: 4.r,
            height: 4.r,
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
