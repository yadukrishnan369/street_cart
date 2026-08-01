import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/services/app_info_service.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/constants/customer_constants.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/about_logo_section.dart';
import 'package:street_cart/features/customer/support/presentation/widgets/about_action_card.dart';
import 'privacy_policy_page.dart';
import 'terms_conditions_page.dart';

// About App Page
class AboutAppPage extends StatelessWidget {
  final IAppInfoService _appInfoService = sl<IAppInfoService>();

  AboutAppPage({super.key});

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
          'About App',
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
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              // App logo
              const AboutLogoSection(),
              SizedBox(height: 24.h),
              // App name header
              Text(
                _appInfoService.appName,
                style: CustomerAppTextStyles.heading1.copyWith(
                  fontSize: 28.sp,
                  color: isDark
                      ? CustomerAppColors.darkTextPrimary
                      : CustomerAppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              // version number label
              Text(
                _appInfoService.fullVersionString,
                style: CustomerAppTextStyles.body.copyWith(
                  color: CustomerAppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 22.h),
              // App tagline text
              Text(
                "Connecting nearby's local shops to\nyour doorstep.",
                textAlign: TextAlign.center,
                style: CustomerAppTextStyles.heading2.copyWith(
                  fontSize: 18.sp,
                  color: isDark
                      ? CustomerAppColors.darkTextPrimary
                      : const Color(0xFF334155),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16.h),
              // App description
              Text(
                CustomerConstants.aboutAppDescription,
                textAlign: TextAlign.center,
                style: CustomerAppTextStyles.body.copyWith(
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : Colors.grey.shade600,
                  height: 1.6,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 18.h),
              // Privacy policy card
              AboutActionCard(
                icon: Icons.star_border_rounded,
                title: 'Privacy Policy',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                ),
              ),
              SizedBox(height: 16.h),
              // Terms of service card
              AboutActionCard(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TermsConditionsPage(),
                  ),
                ),
              ),
              SizedBox(height: 60.h),
              // Copyright footer text
              Text(
                _appInfoService.getCopyrightText(),
                style: CustomerAppTextStyles.body.copyWith(
                  color: isDark
                      ? CustomerAppColors.darkTextSecondary
                      : Colors.grey.shade400,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
