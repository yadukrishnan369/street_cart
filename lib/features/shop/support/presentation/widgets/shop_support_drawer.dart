import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/features/shop/support/presentation/pages/help_support_page.dart';
import 'package:street_cart/features/shop/support/presentation/pages/contact_support_page.dart';
import 'package:street_cart/features/shop/support/presentation/pages/faq_page.dart';
import 'package:street_cart/features/shop/support/presentation/pages/about_app_page.dart';
import 'package:street_cart/features/shop/support/presentation/pages/privacy_policy_page.dart';
import 'package:street_cart/features/shop/support/presentation/pages/terms_conditions_page.dart';
import 'package:street_cart/features/shop/support/presentation/utils/shop_support_helper.dart';

// Shop Support Drawer
class ShopSupportDrawer extends StatelessWidget {
  const ShopSupportDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Row(
                children: [
                  // App Logo
                  AppLogo(
                    size: 40.r,
                    backgroundColor: const Color(0xFFE8F5E9),
                    logoColor: ShopAppColors.primary,
                  ),
                  SizedBox(width: 14.w),
                  // App name
                  Text(
                    'Street Cart',
                    style: ShopAppTextStyles.heading4.copyWith(
                      color: ShopAppColors.primary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Drawer items
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                children: [
                  // Help And Support Section
                  _buildDrawerItem(
                    context,
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Help and Support',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to Help Support Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpSupportPage(),
                        ),
                      );
                    },
                  ),
                  // Contact Support Section
                  _buildDrawerItem(
                    context,
                    icon: Icons.headset_mic_outlined,
                    title: 'Contact Support',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to Contact Support Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactSupportPage(),
                        ),
                      );
                    },
                  ),
                  // FAQ Section
                  _buildDrawerItem(
                    context,
                    icon: Icons.help_outline_outlined,
                    title: 'FAQ',
                    onTap: () {
                      // Navigate to FAQ Page
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FAQPage()),
                      );
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const Divider(color: ShopAppColors.border),
                  ),
                  // About App Section
                  _buildDrawerItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About App',
                    onTap: () {
                      // Navigate to About App Page
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutAppPage()),
                      );
                    },
                  ),
                  // Privacy Policy Section
                  _buildDrawerItem(
                    context,
                    icon: Icons.verified_user_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to Privacy Policy Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyPage(),
                        ),
                      );
                    },
                  ),
                  // Terms and Conditions Section
                  _buildDrawerItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Terms and Conditions',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to Terms Conditions Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TermsConditionsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Bottom Sign Out Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
              child: SizedBox(
                width: double.infinity,
                height: 44.h,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      ShopSupportHelper.showLogoutConfirmation(context),
                  icon: Icon(
                    Icons.logout,
                    size: 18.sp,
                    color: ShopAppColors.primary,
                  ),
                  label: Text(
                    'Sign Out',
                    style: ShopAppTextStyles.bodyMediumBold.copyWith(
                      color: ShopAppColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F3F4),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        onTap: onTap,
        dense: true,
        leading: Icon(icon, color: ShopAppColors.textSecondary, size: 20.sp),
        title: Text(
          title,
          style: ShopAppTextStyles.bodyMediumBold.copyWith(
            color: ShopAppColors.textPrimary,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
