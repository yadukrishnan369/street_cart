import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/constants/shop_constants.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'privacy_policy_page.dart';
import 'terms_conditions_page.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: ShopAppColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
        title: Text(
          'About App',
          style: ShopAppTextStyles.heading4.copyWith(
            color: ShopAppColors.textPrimary,
            fontWeight: FontWeight.bold,
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

              // App Logo Card
              Center(
                child: AppLogo(
                  size: 90.r,
                  backgroundColor: ShopAppColors.primary,
                  logoColor: Colors.white,
                ),
              ),
              SizedBox(height: 24.h),

              // Title & Version
              Text(
                'Street Cart',
                style: ShopAppTextStyles.heading2.copyWith(
                  fontSize: 26.sp,
                  color: ShopAppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Version 2.1.0',
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.primary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Empowering local commerce',
                style: ShopAppTextStyles.bodyMedium.copyWith(
                  color: ShopAppColors.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 24.h),

              // Our Mission Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: const Color(0xFFECEFF1),
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
                        color: ShopAppColors.textSecondary,
                        height: 1.5,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Privacy Policy Action Row
              _buildActionCard(
                context,
                icon: Icons.verified_user_outlined,
                title: 'Privacy Policy',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                ),
              ),
              SizedBox(height: 12.h),

              // Terms & Conditions Action Row
              _buildActionCard(
                context,
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TermsConditionsPage(),
                  ),
                ),
              ),
              SizedBox(height: 48.h),

              // Footer text
              Text(
                '© 2026 Street Cart Technologies Private Limited',
                style: ShopAppTextStyles.bodySmall.copyWith(
                  color: ShopAppColors.textTertiary,
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

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Icon(icon, color: ShopAppColors.primary, size: 22.sp),
        title: Text(
          title,
          style: ShopAppTextStyles.bodyMediumBold.copyWith(
            color: ShopAppColors.textPrimary,
            fontSize: 14.sp,
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
