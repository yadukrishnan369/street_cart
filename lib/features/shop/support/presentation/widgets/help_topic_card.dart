import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class HelpTopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const HelpTopicCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: ShopAppColors.primary, size: 24.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: ShopAppTextStyles.bodyMediumBold.copyWith(
                color: ShopAppColors.textPrimary,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
