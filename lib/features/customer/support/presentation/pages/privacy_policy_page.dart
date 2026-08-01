import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/support_section_block.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/privacy_callout_box.dart';

// Privacy Policy Page
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Policy',
          style: CustomerAppTextStyles.heading2.copyWith(
            fontSize: 20.sp,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // page title and last updated date
            Text(
              'Street Cart Privacy',
              style: CustomerAppTextStyles.heading2.copyWith(
                fontSize: 22.sp,
                color: isDark
                    ? CustomerAppColors.darkTextPrimary
                    : CustomerAppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Information is regularly updated',
              style: CustomerAppTextStyles.body.copyWith(
                color: isDark
                    ? CustomerAppColors.darkTextSecondary
                    : Colors.grey.shade500,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 32.h),
            // data collection overview
            const SupportSectionBlock(
              title: '1. Information We Collect',
              content:
                  'To provide you with the best experience on Street Cart, we collect information that identifies, relates to, describes, or is reasonably capable of being associated with you.',
            ),
            SizedBox(height: 16.h),
            // data type bullet points
            const _PrivacyPoint(
              'Account Data',
              'Name, email address, and phone number when you register.',
            ),
            const _PrivacyPoint(
              'Transaction Info',
              'Details about items purchased, delivery address, and payment confirmation.',
            ),
            const _PrivacyPoint(
              'Device Data',
              'IP address, browser type, and operating system identifiers.',
            ),
            SizedBox(height: 32.h),
            // data usage
            const SupportSectionBlock(
              title: '2. How We Use Data',
              content:
                  'We use the information we collect to operate, maintain, and provide the features of the Street Cart service. This includes processing your orders, managing your wishlist, and providing personalized recommendations based on your shopping habits.',
            ),
            SizedBox(height: 32.h),
            // data sharing
            const SupportSectionBlock(
              title: '3. Data Sharing',
              content:
                  'We do not sell your personal data. We share your information only with:',
            ),
            SizedBox(height: 16.h),
            const PrivacyCalloutBox(
              text:
                  '"Service providers such as delivery partners and payment processors are strictly limited to using your data only for the fulfillment of requested services."',
            ),
            SizedBox(height: 32.h),
            // security measures
            const SupportSectionBlock(
              title: '4. Security',
              content:
                  'Street Cart implements industry-standard encryption and security measures to protect your data. While we strive to use commercially acceptable means to protect your personal information, we cannot guarantee its absolute security.',
            ),
            SizedBox(height: 32.h),
            // user data rights
            const SupportSectionBlock(
              title: '5. Your Rights',
              content:
                  'You have the right to access, correct, or delete your personal information at any time through your Profile settings. If you have questions about your data, please contact our privacy officer.',
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// Privacy Point
class _PrivacyPoint extends StatelessWidget {
  final String boldText;
  final String normalText;

  const _PrivacyPoint(this.boldText, this.normalText);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 16.w),
      child: RichText(
        text: TextSpan(
          style: CustomerAppTextStyles.body.copyWith(
            height: 1.5,
            fontSize: 14.sp,
            color: isDark
                ? CustomerAppColors.darkTextSecondary
                : Colors.grey.shade700,
          ),
          children: [
            TextSpan(
              text: '$boldText: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark
                    ? CustomerAppColors.darkTextPrimary
                    : CustomerAppColors.textPrimary,
              ),
            ),
            TextSpan(text: normalText),
          ],
        ),
      ),
    );
  }
}
