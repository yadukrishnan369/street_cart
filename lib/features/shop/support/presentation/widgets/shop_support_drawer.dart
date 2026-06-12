import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/shared/widgets/app_logo.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/shop/support/presentation/pages/help_support_page.dart';
import 'package:street_cart/features/shop/support/presentation/pages/contact_support_page.dart';
import 'package:street_cart/features/shop/support/presentation/pages/faq_page.dart';
import 'package:street_cart/features/shop/support/presentation/pages/about_app_page.dart';
import 'package:street_cart/features/shop/support/presentation/pages/privacy_policy_page.dart';
import 'package:street_cart/features/shop/support/presentation/pages/terms_conditions_page.dart';

class ShopSupportDrawer extends StatelessWidget {
  const ShopSupportDrawer({super.key});

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationModal(
        title: 'Logout',
        content: 'Are you sure you want to logout from your shop account?',
        confirmText: 'Yes, Logout',
        confirmColor: ShopAppColors.error,
        onConfirm: () {
          Navigator.pop(dialogContext);
          context.read<ShopAuthBloc>().add(ShopLogoutRequested());
        },
        onCancel: () => Navigator.pop(dialogContext),
      ),
    );
  }

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
                  AppLogo(
                    size: 40.r,
                    backgroundColor: const Color(0xFFE8F5E9),
                    logoColor: ShopAppColors.primary,
                  ),
                  SizedBox(width: 14.w),
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
                  _buildDrawerItem(
                    context,
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Help and Support',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpSupportPage(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.headset_mic_outlined,
                    title: 'Contact Support',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContactSupportPage(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.help_outline_outlined,
                    title: 'FAQ',
                    onTap: () {
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

                  _buildDrawerItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About App',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutAppPage()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.verified_user_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyPage(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Terms and Conditions',
                    onTap: () {
                      Navigator.pop(context);
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

            // Bottom Sign Out
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
              child: SizedBox(
                width: double.infinity,
                height: 44.h,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutConfirmation(context),
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
