import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

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
    final String stockText = stockQuantity != totalQuantity
        ? '$stockQuantity / $totalQuantity units'
        : '$stockQuantity units';

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'STOCK',
            stockText,
            stockQuantity > 0 ? ShopAppColors.success : ShopAppColors.error,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildStatCard(
            'TOTAL PRODUCT SALES',
            '$salesCount units',
            Colors.blue[700]!,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
              color: ShopAppColors.textSecondary,
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
