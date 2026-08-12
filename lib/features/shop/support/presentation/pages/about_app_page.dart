import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/constants/shop_constants.dart';
import 'package:street_cart/core/services/app_info_service.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/features/shop/support/presentation/widgets/about_app_action_card.dart';
import 'privacy_policy_page.dart';
import 'terms_conditions_page.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// About App Page
class AboutAppPage extends StatelessWidget {
  final IAppInfoService _appInfoService = sl<IAppInfoService>();

  AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? ShopAppColors.darkBackground
          : const Color(0xFFF8F9FA),
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
          'About App',
          style: ShopAppTextStyles.heading2.copyWith(
            fontSize: 18.sp,
            color: isDark
                ? ShopAppColors.darkTextPrimary
                : ShopAppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 36.h),
              // App logo section
              Center(
                child: AppLogo(
                  size: 90.r,
                  backgroundColor: ShopAppColors.primary,
                  logoColor: Colors.white,
                ),
              ),
              SizedBox(height: 24.h),

              // App name & Version
              Text(
                _appInfoService.appName,
                style: ShopAppTextStyles.heading2.copyWith(
                  fontSize: 20.sp,
                  color: isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                _appInfoService.fullVersionString,
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.primary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Empowering local commerce',
                style: ShopAppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextSecondary
                      : ShopAppColors.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 24.h),

              // Our Mission Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: isDark ? ShopAppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isDark
                        ? ShopAppColors.darkBorder
                        : const Color(0xFFECEFF1),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.groups_outlined,
                          color: ShopAppColors.primary,
                          size: 22.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Our Mission',
                          style: ShopAppTextStyles.bodyMediumBold.copyWith(
                            color: ShopAppColors.primary,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      ShopConstants.aboutAppDescription,
                      style: ShopAppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : ShopAppColors.textSecondary,
                        height: 1.5,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Privacy Policy Action
              AboutAppActionCard(
                icon: Icons.verified_user_outlined,
                title: 'Privacy Policy',
                // Navigate to Privacy Policy Page
                onTap: () => Navigator.push(
                  context,
                  AppPageTransitions.slide(const PrivacyPolicyPage()),
                ),
              ),
              SizedBox(height: 12.h),

              // Terms & Conditions Action
              AboutAppActionCard(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                // Navigate to Terms Conditions Page
                onTap: () => Navigator.push(
                  context,
                  AppPageTransitions.slide(const TermsConditionsPage()),
                ),
              ),
              SizedBox(height: 48.h),

              // Footer text
              Text(
                _appInfoService.getCopyrightText(''),
                style: ShopAppTextStyles.bodySmall.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextSecondary
                      : ShopAppColors.textTertiary,
                  fontSize: 11.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
