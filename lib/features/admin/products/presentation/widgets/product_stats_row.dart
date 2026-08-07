import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';

// Product Stats Row
class ProductStatsRow extends StatelessWidget {
  final AdminProductItem productItem;

  const ProductStatsRow({super.key, required this.productItem});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = productItem.product;
    return Row(
      children: [
        // Price Section
        Expanded(
          child: _buildStatItemCard(
            context,
            label: 'PRICE',
            value: p.offerPrice != null
                ? '₹${p.offerPrice!.toStringAsFixed(2)}'
                : '₹${p.originalPrice.toStringAsFixed(2)}',
            labelColor: AdminAppColors.primaryColor,
            valueColor: AdminAppColors.primaryColor,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          // Stock Section
          child: _buildStatItemCard(
            context,
            label: 'STOCK',
            value: '${p.stockQuantity} Units',
            labelColor: isDark
                ? AdminAppColors.darkTextSecondary
                : const Color(0xFF667085),
            valueColor: isDark
                ? AdminAppColors.darkTextPrimary
                : AdminAppColors.textPrimary,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          // Category Section
          child: _buildStatItemCard(
            context,
            label: 'CATEGORY',
            value: p.category,
            labelColor: isDark
                ? AdminAppColors.darkTextSecondary
                : const Color(0xFF667085),
            valueColor: isDark
                ? AdminAppColors.darkTextPrimary
                : AdminAppColors.textPrimary,
          ),
        ),
        SizedBox(width: 16.w),
        // Sales Section
        Expanded(
          child: _buildStatItemCard(
            context,
            label: 'SALES',
            value: '${productItem.orderCount} Units',
            labelColor: isDark
                ? AdminAppColors.darkTextSecondary
                : const Color(0xFF667085),
            valueColor: isDark
                ? AdminAppColors.darkTextPrimary
                : AdminAppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItemCard(
    BuildContext context, {
    required String label,
    required String value,
    required Color labelColor,
    required Color valueColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFEAECF0),
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: labelColor,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
