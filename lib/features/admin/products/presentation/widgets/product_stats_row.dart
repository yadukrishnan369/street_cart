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
    final p = productItem.product;
    return Row(
      children: [
        // Price Section
        Expanded(
          child: _buildStatItemCard(
            label: 'PRICE',
            value: p.offerPrice != null
                ? '₹${p.offerPrice!.toStringAsFixed(2)}'
                : '₹${p.originalPrice.toStringAsFixed(2)}',
            bg: Colors.white,
            labelColor: AdminAppColors.primaryColor,
            valueColor: AdminAppColors.primaryColor,
            hasBorder: true,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          // Stock Section
          child: _buildStatItemCard(
            label: 'STOCK',
            value: '${p.stockQuantity} Units',
            bg: Colors.white,
            labelColor: const Color(0xFF667085),
            valueColor: const Color(0xFF1D2939),
            hasBorder: true,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          // Category Section
          child: _buildStatItemCard(
            label: 'CATEGORY',
            value: p.category,
            bg: Colors.white,
            labelColor: const Color(0xFF667085),
            valueColor: const Color(0xFF1D2939),
            hasBorder: true,
          ),
        ),
        SizedBox(width: 16.w),
        // Sales Section
        Expanded(
          child: _buildStatItemCard(
            label: 'SALES',
            value: '${p.salesCount} Units',
            bg: Colors.white,
            labelColor: const Color(0xFF667085),
            valueColor: const Color(0xFF1D2939),
            hasBorder: true,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItemCard({
    required String label,
    required String value,
    required Color bg,
    required Color labelColor,
    required Color valueColor,
    bool hasBorder = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
        border: hasBorder
            ? Border.all(color: const Color(0xFFEAECF0), width: 1.5)
            : null,
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
