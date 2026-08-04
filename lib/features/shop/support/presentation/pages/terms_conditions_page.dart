import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

// Terms Conditions Page
class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? ShopAppColors.darkBackground : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? ShopAppColors.darkBackground : Colors.white,
        elevation: isDark ? null : 1.5,
        shape: Border(
          bottom: BorderSide(
            color: isDark
                ? ShopAppColors.darkBorder
                : ShopAppColors.border.withValues(alpha: 1.5),
            width: 0.5,
          ),
        ),
        // Page Header
        title: Text(
          'Terms & Conditions',
          style: ShopAppTextStyles.heading4.copyWith(
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
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
            SizedBox(height: 24.h),

            // Acceptance of Terms
            _buildSectionHeader(context, '1. Acceptance of Terms'),
            _buildSectionBody(
              context,
              'Welcome to Street Cart. By using our platform to manage your shop, you agree to comply with and be bound by the following terms and conditions of use, which together with our privacy policy govern Street Cart\'s relationship with you.',
            ),

            // Merchant Responsibilities
            _buildSectionHeader(context, '2. Merchant Responsibilities'),
            _buildSectionBody(
              context,
              'As a shop owner on Street Cart, you are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
            ),
            SizedBox(height: 8.h),
            _buildBulletItem(
              context,
              'You must provide accurate information regarding your business and products.',
            ),
            _buildBulletItem(
              context,
              'You are responsible for fulfilling orders in a timely manner.',
            ),
            _buildBulletItem(
              context,
              'You must comply with all local tax and business regulations.',
            ),
            SizedBox(height: 12.h),

            // Fees and Payments
            _buildSectionHeader(context, '3. Fees and Payments'),
            _buildSectionBody(
              context,
              'Street Cart charges a processing fee on each transaction completed through the platform. These fees are subject to change with a 30-day notice. All payouts are processed within 3-5 business days of order completion.',
            ),

            // Prohibited Content
            _buildSectionHeader(context, '4. Prohibited Content'),
            _buildSectionBody(
              context,
              'Users may not list items that are illegal, hazardous, or infringe on the intellectual property rights of others. Street Cart reserves the right to remove any product listing that violates these terms.',
            ),

            // Privacy and Data
            _buildSectionHeader(context, '5. Privacy and Data'),
            _buildSectionBody(
              context,
              'We value your privacy. Merchant data is used solely for the purpose of facilitating transactions and improving our service. We do not sell your business data to third parties.',
            ),

            // Limitation of Liability
            _buildSectionHeader(context, '6. Limitation of Liability'),
            _buildSectionBody(
              context,
              'Street Cart shall not be liable for any indirect, incidental, special, or consequential damages resulting from the use or inability to use the service.',
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 16.h),
      child: Text(
        title,
        style: ShopAppTextStyles.bodyMediumBold.copyWith(
          color: isDark
              ? ShopAppColors.darkTextPrimary
              : ShopAppColors.textPrimary,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionBody(BuildContext context, String bodyText) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      bodyText,
      style: ShopAppTextStyles.bodyMedium.copyWith(
        color: isDark
            ? ShopAppColors.darkTextSecondary
            : ShopAppColors.textSecondary,
        height: 1.5,
        fontSize: 13.sp,
      ),
    );
  }

  Widget _buildBulletItem(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(left: 12.w, bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h),
            width: 4.r,
            height: 4.r,
            decoration: BoxDecoration(
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: ShopAppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? ShopAppColors.darkTextSecondary
                    : ShopAppColors.textSecondary,
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
