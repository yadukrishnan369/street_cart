import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: ShopAppTextStyles.bodyLargeBold),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionCard('Add Product', Icons.inventory_2_outlined, true),
            _buildActionCard('View Orders', Icons.widgets_outlined, false),
            _buildActionCard('Edit Profile', Icons.edit_square, false),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, bool isPrimary) {
    return Container(
      width: 90.w,
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: BoxDecoration(
        color: isPrimary ? ShopAppColors.primary : ShopAppColors.surface,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: isPrimary ? ShopAppColors.primary : ShopAppColors.border,
          width: 1.5.w,
        ),
        boxShadow: [
          if (isPrimary)
            BoxShadow(
              color: ShopAppColors.primary.withOpacity(0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 26.sp,
            color: isPrimary ? Colors.white : ShopAppColors.primary,
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: ShopAppTextStyles.bodySmallBold.copyWith(
              color: isPrimary ? Colors.white : ShopAppColors.textSecondary,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
