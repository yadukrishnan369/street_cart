import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/constants/shop_constants.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  void _callSupport(BuildContext context, CommunicationService comms) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Call Support',
        content:
            'Are you sure you want to call our support team at ${ShopConstants.supportPhoneNumber}?',
        confirmText: 'Call',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext);
          comms.makeCall(ShopConstants.supportPhoneNumber);
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  void _emailSupport(BuildContext context, CommunicationService comms) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Email Support',
        content:
            'Do you want to send an email to ${ShopConstants.supportEmail}?',
        confirmText: 'Send',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(dialogContext);
          comms.sendEmail(ShopConstants.supportEmail);
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final comms = sl<CommunicationService>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ShopAppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Contact Support',
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
          children: [
            // Agent Illustration
            Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE).withOpacity(0.3),
                borderRadius: BorderRadius.circular(24.r),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.support_agent_rounded,
                  size: 84.sp,
                  color: ShopAppColors.primary,
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // Title & Subtext
            Text(
              "We're here to help!",
              style: ShopAppTextStyles.heading2.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Our dedicated Street Cart support team is available Monday to Friday, 9:00 AM - 6:00 PM EST to help you grow your business and resolve any issues.',
              style: ShopAppTextStyles.bodyMedium.copyWith(
                color: ShopAppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 36.h),

            // Call Support Row
            _buildContactRow(
              icon: Icons.phone_in_talk_outlined,
              title: 'Call Support',
              subtitle: 'Speak with an agent now',
              onTap: () => _callSupport(context, comms),
            ),
            SizedBox(height: 14.h),

            // Email Support Row
            _buildContactRow(
              icon: Icons.mail_outline_rounded,
              title: 'Email Support',
              subtitle: 'Response within 24 hours',
              onTap: () => _emailSupport(context, comms),
            ),
            SizedBox(height: 60.h),

            Text(
              'Street Cart Seller App v2.4.0',
              style: ShopAppTextStyles.bodySmall.copyWith(
                color: ShopAppColors.textTertiary,
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5E9),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: ShopAppColors.primary, size: 22.sp),
        ),
        title: Text(
          title,
          style: ShopAppTextStyles.bodyMediumBold.copyWith(
            color: ShopAppColors.textPrimary,
            fontSize: 14.sp,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Text(
            subtitle,
            style: ShopAppTextStyles.bodySmall.copyWith(
              color: ShopAppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14.sp,
          color: ShopAppColors.textSecondary,
        ),
      ),
    );
  }
}
