import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Product Description Section
class ProductDescriptionSection extends StatelessWidget {
  final String description;

  const ProductDescriptionSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Description',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        // Description
        Text(
          description,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark
                ? CustomerAppColors.darkTextSecondary
                : CustomerAppColors.textSecondary,
            height: 1.5,
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }
}
