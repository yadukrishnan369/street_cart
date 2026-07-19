import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

// Contact Support Page - Contact Support Row
class ContactSupportRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ContactSupportRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      // List Tile
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: const BoxDecoration(
            color: Color(0xFFE8F5E9),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: ShopAppColors.primary, size: 22.sp),
        ),
        // Title
        title: Text(
          title,
          style: ShopAppTextStyles.bodyMediumBold.copyWith(
            color: ShopAppColors.textPrimary,
            fontSize: 14.sp,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 2.h),
          // Subtitle
          child: Text(
            subtitle,
            style: ShopAppTextStyles.bodySmall.copyWith(
              color: ShopAppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
        ),
        // Icon
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14.sp,
          color: ShopAppColors.textSecondary,
        ),
      ),
    );
  }
}
