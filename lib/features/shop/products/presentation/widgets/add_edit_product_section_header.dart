import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class AddEditProductSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AddEditProductSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: ShopAppColors.primaryLight,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: ShopAppColors.primary, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: ShopAppTextStyles.heading3),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ShopAppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
