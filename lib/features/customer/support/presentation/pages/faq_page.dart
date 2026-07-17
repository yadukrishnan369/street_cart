import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/constants/customer_constants.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/faq_expansion_tile.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/support_footer_box.dart';
import 'contact_support_page.dart';

// FAQ Page
class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

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
        // Page Title
        title: Text(
          'FAQ',
          style: CustomerAppTextStyles.heading2.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              SizedBox(height: 32.h),
              Text(
                'FREQUENTLY ASKED QUESTIONS',
                style: CustomerAppTextStyles.body.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: CustomerAppColors.primary,
                ),
              ),
              SizedBox(height: 16.h),
              ...CustomerConstants.faqs.map(
                (faq) => FAQExpansionTile(
                  question: faq['question']!,
                  answer: faq['answer']!,
                ),
              ),
              SizedBox(height: 24.h),
              // Support Footer Box
              SupportFooterBox(
                title: 'Still need help?',
                subtitle:
                    "Can't find the answer you're looking for? Please call or email our friendly team.",
                buttonText: 'Get in Touch',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ContactSupportPage(),
                    ),
                  );
                },
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1FF),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How can we help you?',
            style: CustomerAppTextStyles.heading2.copyWith(
              fontSize: 22.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Find answers to your questions about orders, payments, and how Street Cart works.',
            style: CustomerAppTextStyles.body.copyWith(
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
