import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomerAppColors.background,
      appBar: AppBar(
        backgroundColor: CustomerAppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Policy',
          style: CustomerAppTextStyles.heading2.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Street Cart Privacy',
              style: CustomerAppTextStyles.heading2.copyWith(
                fontSize: 22.sp,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Last updated: October 24, 2023',
              style: CustomerAppTextStyles.body.copyWith(
                color: Colors.grey.shade500,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 32.h),
            _buildSection(
              '1. Information We Collect',
              'To provide you with the best experience on Street Cart, we collect information that identifies, relates to, describes, or is reasonably capable of being associated with you.',
            ),
            SizedBox(height: 16.h),
            _buildPoint(
              'Account Data',
              'Name, email address, and phone number when you register.',
            ),
            _buildPoint(
              'Transaction Info',
              'Details about items purchased, delivery address, and payment confirmation.',
            ),
            _buildPoint(
              'Device Data',
              'IP address, browser type, and operating system identifiers.',
            ),
            SizedBox(height: 32.h),
            _buildSection(
              '2. How We Use Data',
              'We use the information we collect to operate, maintain, and provide the features of the Street Cart service. This includes processing your orders, managing your wishlist, and providing personalized recommendations based on your shopping habits.',
            ),
            SizedBox(height: 32.h),
            _buildSection(
              '3. Data Sharing',
              'We do not sell your personal data. We share your information only with:',
            ),
            SizedBox(height: 16.h),
            _buildCalloutBox(
              '"Service providers such as delivery partners and payment processors are strictly limited to using your data only for the fulfillment of requested services."',
            ),
            SizedBox(height: 32.h),
            _buildSection(
              '4. Security',
              'Street Cart implements industry-standard encryption and security measures to protect your data. While we strive to use commercially acceptable means to protect your personal information, we cannot guarantee its absolute security.',
            ),
            SizedBox(height: 32.h),
            _buildSection(
              '5. Your Rights',
              'You have the right to access, correct, or delete your personal information at any time through your Profile settings. If you have questions about your data, please contact our privacy officer.',
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: CustomerAppTextStyles.heading2.copyWith(
            fontSize: 18.sp,
            color: CustomerAppColors.primary,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          content,
          style: CustomerAppTextStyles.body.copyWith(
            height: 1.6,
            fontSize: 14.sp,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildPoint(String boldText, String normalText) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 16.w),
      child: RichText(
        text: TextSpan(
          style: CustomerAppTextStyles.body.copyWith(
            height: 1.5,
            fontSize: 14.sp,
            color: Colors.grey.shade700,
          ),
          children: [
            TextSpan(
              text: '$boldText: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: normalText),
          ],
        ),
      ),
    );
  }

  Widget _buildCalloutBox(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: CustomerAppColors.primary.withOpacity(0.1)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: CustomerAppTextStyles.body.copyWith(
          color: const Color(0xFF475569),
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
      ),
    );
  }
}
