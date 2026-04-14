import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/support/presentation/pages/help_support_page.dart';
import 'package:street_cart/features/customer/support/presentation/pages/contact_support_page.dart';
import 'package:street_cart/features/customer/support/presentation/pages/faq_page.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUPPORT',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                _buildListTile(
                  context,
                  Icons.help_outline,
                  'Help & Support',
                  const HelpSupportPage(),
                ),
                Divider(height: 1, indent: 48.w, color: Colors.grey.shade100),
                _buildListTile(
                  context,
                  Icons.chat_bubble_outline,
                  'Contact Support',
                  const ContactSupportPage(),
                ),
                Divider(height: 1, indent: 48.w, color: Colors.grey.shade100),
                _buildListTile(
                  context,
                  Icons.warning_amber_rounded,
                  'FAQ / Report Issue',
                  const FAQPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(icon, color: CustomerAppColors.primary, size: 20.sp),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
