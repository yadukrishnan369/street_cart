import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/constants/customer_constants.dart';
import 'faq_page.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

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
          'Contact Support',
          style: CustomerAppTextStyles.heading2.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              _buildIllustration(),
              SizedBox(height: 32.h),
              Text(
                'How can we help?',
                style: CustomerAppTextStyles.heading2.copyWith(fontSize: 24.sp),
              ),
              SizedBox(height: 12.h),
              Text(
                'Our support team is here to assist you with any questions about your orders or our services. You can reach us via phone during business hours or send us an email anytime.',
                textAlign: TextAlign.center,
                style: CustomerAppTextStyles.body.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40.h),
              _buildSupportHours(),
              SizedBox(height: 16.h),
              _buildContactButton(
                icon: Icons.phone_outlined,
                label: 'Call Support',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmationModal(
                      title: 'Call Support',
                      content:
                          'Are you sure you want to call our support team at ${CustomerConstants.supportPhoneNumber}?',
                      confirmText: 'Call',
                      onConfirm: () {
                        Navigator.pop(context);
                        sl<CommunicationService>().makeCall(
                          CustomerConstants.supportPhoneNumber,
                        );
                      },
                      onCancel: () => Navigator.pop(context),
                    ),
                  );
                },
              ),
              SizedBox(height: 12.h),
              _buildContactButton(
                icon: Icons.email_outlined,
                label: 'Email Us',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmationModal(
                      title: 'Email Us',
                      content:
                          'Do you want to send an email to ${CustomerConstants.supportEmail}?',
                      confirmText: 'Send',
                      onConfirm: () {
                        Navigator.pop(context);
                        sl<CommunicationService>().sendEmail(
                          CustomerConstants.supportEmail,
                        );
                      },
                      onCancel: () => Navigator.pop(context),
                    ),
                  );
                },
              ),
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Looking for quick answers? ',
                    style: CustomerAppTextStyles.body.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FAQPage()),
                      );
                    },
                    child: Text(
                      'Visit our FAQs',
                      style: CustomerAppTextStyles.body.copyWith(
                        color: CustomerAppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1FF),
        borderRadius: BorderRadius.circular(32.r),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8EAFF), Color(0xFFF5F6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.support_agent_rounded,
          size: 100.sp,
          color: CustomerAppColors.primary.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildSupportHours() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: CustomerAppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: CustomerAppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_filled,
              color: CustomerAppColors.primary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SUPPORT HOURS',
                style: CustomerAppTextStyles.body.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                CustomerConstants.supportHours,
                style: CustomerAppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade200),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: CustomerAppColors.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20.sp, color: Colors.black87),
            SizedBox(width: 12.w),
            Text(
              label,
              style: CustomerAppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
