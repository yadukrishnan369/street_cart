import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/constants/customer_constants.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/support_illustration_banner.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/support_hours_card.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/support_contact_button.dart';
import 'faq_page.dart';

// Contact Support Page
class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

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
          'Contact Support',
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
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              // Banner with support illustration
              const SupportIllustrationBanner(),
              SizedBox(height: 32.h),
              // Help header
              Text(
                'How can we help?',
                style: CustomerAppTextStyles.heading2.copyWith(
                  fontSize: 24.sp,
                  color: isDark
                      ? CustomerAppColors.darkTextPrimary
                      : CustomerAppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              // Description Content
              Text(
                'Our support team is here to assist you with any questions about your orders or our services. You can reach us via phone during business hours or send us an email anytime.',
                textAlign: TextAlign.center,
                style: CustomerAppTextStyles.body.copyWith(
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40.h),
              // Support hours badge card
              const SupportHoursCard(),
              SizedBox(height: 16.h),
              // Call support action button
              SupportContactButton(
                icon: Icons.phone_outlined,
                label: 'Call Support',
                onPressed: () => _showCallDialog(context),
              ),
              SizedBox(height: 12.h),
              // Email support action button
              SupportContactButton(
                icon: Icons.email_outlined,
                label: 'Email Us',
                onPressed: () => _showEmailDialog(context),
              ),
              SizedBox(height: 40.h),
              // Faq quick action
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Looking for quick answers? ',
                    style: CustomerAppTextStyles.body.copyWith(
                      color: isDark
                          ? CustomerAppColors.darkTextSecondary
                          : Colors.grey.shade600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FAQPage()),
                    ),
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

  // confirmation before making a phone call
  void _showCallDialog(BuildContext context) {
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
  }

  // confirmation before opening email
  void _showEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationModal(
        title: 'Email Us',
        content:
            'Do you want to send an email to ${CustomerConstants.supportEmail}?',
        confirmText: 'Send',
        onConfirm: () {
          Navigator.pop(context);
          sl<CommunicationService>().sendEmail(CustomerConstants.supportEmail);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }
}
