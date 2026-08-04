import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

// Product Detail Stats
class ProductDetailStats extends StatelessWidget {
  final int stockQuantity;
  final int totalQuantity;
  final int salesCount;

  const ProductDetailStats({
    super.key,
    required this.stockQuantity,
    required this.totalQuantity,
    required this.salesCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final String stockText = stockQuantity != totalQuantity
        ? '$stockQuantity / $totalQuantity units'
        : '$stockQuantity units';

    return Row(
      children: [
        Expanded(
          // Total Stock Section
          child: _buildStatCard(
            context,
            'STOCK',
            stockText,
            stockQuantity > 0 ? ShopAppColors.success : ShopAppColors.error,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          // Total Product Sale Section
          child: _buildStatCard(
            context,
            'TOTAL PRODUCT SALES',
            '$salesCount units',
            isDark ? Colors.blue[400]! : Colors.blue[700]!,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: ShopAppTextStyles.caption.copyWith(
              color: isDark
                  ? ShopAppColors.darkTextSecondary
                  : ShopAppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
