import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/support_section_block.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/terms_checklist_box.dart';

// Terms Conditions Page
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
            // top icon badge
            _TermsTopIcon(),
            SizedBox(height: 24.h),
            // agreement title
            Text(
              'Street Cart Service Agreement',
              style: CustomerAppTextStyles.heading2.copyWith(
                fontSize: 22.sp,
                color: const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Last updated: October 24, 2026',
              style: CustomerAppTextStyles.body.copyWith(
                color: Colors.grey.shade500,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 32.h),
            // introduction section
            const SupportSectionBlock(
              title: '1. Introduction',
              content:
                  'Welcome to Street Cart. These terms and conditions outline the rules and regulations for the use of our platform, mobile application, and the delivery services we coordinate for local shops. By accessing this platform, we assume you accept these terms and conditions.',
            ),
            SizedBox(height: 32.h),
            // delivery terms section with sub points
            const SupportSectionBlock(
              title: '2. Delivery Terms',
              content:
                  'Street Cart acts as a bridge between local vendors and consumers. Delivery times provided are estimates and may vary based on traffic, weather, or shop preparation times.',
            ),
            _TermsSubPoint(
              'Maximum delivery radius is currently 5km from the shop location.',
            ),
            _TermsSubPoint(
              'Perishable goods must be accepted immediately upon arrival.',
            ),
            _TermsSubPoint(
              'Street Cart is not liable for minor delays caused by vendor preparation.',
            ),
            SizedBox(height: 32.h),
            // user responsibility section with checklist
            Text(
              '3. User Responsibilities',
              style: CustomerAppTextStyles.heading2.copyWith(
                fontSize: 18.sp,
                color: CustomerAppColors.primary,
              ),
            ),
            SizedBox(height: 12.h),
            const TermsChecklistBox(
              steps: [
                'Provide accurate delivery addresses and contact information.',
                'Be present or available at the specified delivery location.',
                'Treat delivery partners with respect and courtesy.',
              ],
            ),
            SizedBox(height: 32.h),
            // payments and refunds section
            const SupportSectionBlock(
              title: '4. Payments & Refunds',
              content:
                  "All payments are processed securely through our authorized payment gateways. Refunds for cancellations are subject to the vendor's specific return policy and the stage of order preparation.",
            ),
            SizedBox(height: 48.h),
            // footer divider
            Container(
              width: double.infinity,
              height: 1.h,
              color: Colors.grey.shade100,
            ),
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
}

// Terms Top Icon
class _TermsTopIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

// Terms Sub Point
class _TermsSubPoint extends StatelessWidget {
  final String text;
  const _TermsSubPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // bullet dot
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
              style: const TextStyle().copyWith(
                fontSize: 13,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
