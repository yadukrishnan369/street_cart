import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/core/constants/customer_constants.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'privacy_policy_page.dart';
import 'terms_conditions_page.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

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
          'About App',
          style: CustomerAppTextStyles.heading2.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              _buildLogoSection(),
              SizedBox(height: 24.h),
              Text(
                'Street Cart',
                style: CustomerAppTextStyles.heading1.copyWith(
                  fontSize: 28.sp,
                  color: const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Version 2.1.0',
                style: CustomerAppTextStyles.body.copyWith(
                  color: CustomerAppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 22.h),
              Text(
                "Connecting nearby's local shops to\nyour doorstep.",
                textAlign: TextAlign.center,
                style: CustomerAppTextStyles.heading2.copyWith(
                  fontSize: 18.sp,
                  color: const Color(0xFF334155),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                CustomerConstants.aboutAppDescription,
                textAlign: TextAlign.center,
                style: CustomerAppTextStyles.body.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.6,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 18.h),
              _buildActionCard(
                context,
                icon: Icons.star_border_rounded,
                title: 'Privacy Policy',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                ),
              ),
              SizedBox(height: 16.h),
              _buildActionCard(
                context,
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
              Text(
                '© 2026 Street Cart',
                style: CustomerAppTextStyles.body.copyWith(
                  color: Colors.grey.shade400,
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

  Widget _buildLogoSection() {
    return Container(
      width: 140.w,
      height: 140.w,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEFFF),
        borderRadius: BorderRadius.circular(36.r),
      ),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: CustomerAppColors.primary,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: CustomerAppColors.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(child: AppLogo(isDark: true, size: 80.w)),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: CustomerAppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Icon(icon, color: CustomerAppColors.primary, size: 24.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: CustomerAppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
