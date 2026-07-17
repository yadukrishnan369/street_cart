import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';

// About Action Card
class AboutActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const AboutActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
            // leading icon
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
            // trailing arrow
            Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
