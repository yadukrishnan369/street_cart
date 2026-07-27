import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

// Sales Items Count Cards
class SalesItemsCountCards extends StatelessWidget {
  final int salesCount;
  final int itemsCount;

  const SalesItemsCountCards({
    super.key,
    required this.salesCount,
    required this.itemsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Sales Count
          Expanded(
            child: _buildCountCell(
              title: 'Sales Count',
              value: salesCount.toString(),
              icon: Icons.shopping_bag_rounded,
              iconColor: const Color(0xFF0EA5E9),
            ),
          ),
          // Divider
          Container(width: 1, height: 54.h, color: const Color(0xFFE2E8F0)),
          // Items Sold
          Expanded(
            child: _buildCountCell(
              title: 'Items Sold',
              value: itemsCount.toString(),
              icon: Icons.inventory_2_rounded,
              iconColor: const Color(0xFF8B5CF6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountCell({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16.sp),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: ShopAppTextStyles.caption.copyWith(
                    color: ShopAppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: ShopAppTextStyles.heading2.copyWith(
                    color: const Color(0xFF0F172A),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
