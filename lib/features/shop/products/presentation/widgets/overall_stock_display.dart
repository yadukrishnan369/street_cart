import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Overall Stock Display
class OverallStockDisplay extends StatelessWidget {
  final int totalStock;

  const OverallStockDisplay({super.key, required this.totalStock});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isInStock = totalStock > 0;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isInStock
              ? [
                  ShopAppColors.success.withValues(alpha: isDark ? 0.2 : 0.08),
                  ShopAppColors.success.withValues(alpha: isDark ? 0.1 : 0.03),
                ]
              : (isDark
                    ? [ShopAppColors.darkSurface, ShopAppColors.darkBackground]
                    : [Colors.grey[100]!, Colors.grey[50]!]),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isInStock
              ? ShopAppColors.success.withValues(alpha: 0.3)
              : (isDark ? ShopAppColors.darkBorder : Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isInStock
                  ? ShopAppColors.success.withValues(alpha: 0.15)
                  : (isDark ? ShopAppColors.darkBorder : Colors.grey[200]),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: isInStock
                  ? ShopAppColors.success
                  : (isDark
                        ? ShopAppColors.darkTextSecondary
                        : ShopAppColors.textSecondary),
              size: 20.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Overall Product Stock',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark
                        ? ShopAppColors.darkTextSecondary
                        : ShopAppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                // Total Stock Count
                Text(
                  '$totalStock items total',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: isInStock
                        ? ShopAppColors.success
                        : (isDark
                              ? ShopAppColors.darkTextSecondary
                              : ShopAppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          Text(
            isInStock ? 'In Stock' : 'Out of Stock',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: isInStock ? ShopAppColors.success : ShopAppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
