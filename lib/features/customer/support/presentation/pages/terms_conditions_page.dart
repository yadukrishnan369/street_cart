import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

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
          'Terms & Conditions',
          style: CustomerAppTextStyles.heading2.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopIcon(),
            SizedBox(height: 24.h),
            Text(
              'Street Cart Service Agreement',
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
              '1. Introduction',
              'Welcome to Street Cart. These terms and conditions outline the rules and regulations for the use of our platform, mobile application, and the delivery services we coordinate for local shops. By accessing this platform, we assume you accept these terms and conditions.',
            ),
            SizedBox(height: 32.h),
            _buildSection(
              '2. Delivery Terms',
              'Street Cart acts as a bridge between local vendors and consumers. Delivery times provided are estimates and may vary based on traffic, weather, or shop preparation times.',
            ),
            _buildSubPoint(
              'Maximum delivery radius is currently 5km from the shop location.',
            ),
            _buildSubPoint(
              'Perishable goods must be accepted immediately upon arrival.',
            ),
            _buildSubPoint(
              'Street Cart is not liable for minor delays caused by vendor preparation.',
            ),
            SizedBox(height: 32.h),
            _buildSectionTitle('3. User Responsibilities'),
            SizedBox(height: 12.h),
            _buildChecklist([
              'Provide accurate delivery addresses and contact information.',
              'Be present or available at the specified delivery location.',
              'Treat delivery partners with respect and courtesy.',
            ]),
            SizedBox(height: 32.h),
            _buildSection(
              '4. Payments & Refunds',
              "All payments are processed securely through our authorized payment gateways. Refunds for cancellations are subject to the vendor's specific return policy and the stage of order preparation.",
            ),
            SizedBox(height: 48.h),
            _buildFooterDivider(),
            SizedBox(height: 24.h),
            Text(
              'If you have any questions about these Terms, please contact our support team via the Profile section.',
              textAlign: TextAlign.center,
              style: CustomerAppTextStyles.body.copyWith(
                fontSize: 11.sp,
                color: Colors.grey.shade400,
                height: 1.5,
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTopIcon() {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEFFF),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Icon(Icons.gavel, color: CustomerAppColors.primary, size: 24.sp),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        SizedBox(height: 12.h),
        Text(
          content,
          style: CustomerAppTextStyles.body.copyWith(
            height: 1.6,
            fontSize: 14.sp,
            color: const Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: CustomerAppTextStyles.heading2.copyWith(
        fontSize: 18.sp,
        color: CustomerAppColors.primary,
      ),
    );
  }

  Widget _buildSubPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: 4.w,
            height: 4.w,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: CustomerAppTextStyles.body.copyWith(
                fontSize: 13.sp,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklist(List<String> steps) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: CustomerAppColors.background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Text(
            'As a user of Street Cart, you agree to:',
            style: CustomerAppTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: const Color(0xFF475569),
            ),
          ),
          SizedBox(height: 16.h),
          ...steps.map(
            (step) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18.sp,
                    color: CustomerAppColors.primary.withOpacity(0.7),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      step,
                      style: CustomerAppTextStyles.body.copyWith(
                        fontSize: 13.sp,
                        color: const Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterDivider() {
    return Container(
      width: double.infinity,
      height: 1.h,
      color: Colors.grey.shade100,
    );
  }
}
