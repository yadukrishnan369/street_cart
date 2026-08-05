import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

// Product Description Section
class ProductDescriptionSection extends StatelessWidget {
  final ProductModel product;

  const ProductDescriptionSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = product;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      padding: EdgeInsets.all(32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Title
          Text(
            'Product Description',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: isDark
                  ? AdminAppColors.darkTextPrimary
                  : AdminAppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          // Product Description
          Text(
            p.description.isNotEmpty
                ? p.description
                : 'No description provided for this product.',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark
                  ? AdminAppColors.darkTextSecondary
                  : const Color(0xFF4B5563),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
