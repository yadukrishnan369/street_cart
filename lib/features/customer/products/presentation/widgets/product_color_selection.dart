import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Product Color Selection
class ProductColorSelection extends StatelessWidget {
  final List<String> colors;
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;

  const ProductColorSelection({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Colors',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: CustomerAppColors.textPrimary,
              ),
            ),
            Text(
              'COLOR CHART',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: CustomerAppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // List of Available Colors
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: colors.map((colorName) {
              final color = ShopAppColors.getColorFromName(colorName);
              final isSelected = selectedColor == colorName;
              final isWhite = color.toARGB32() == 0xFFFFFFFF;
              return GestureDetector(
                onTap: () => onColorSelected(colorName),
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? CustomerAppColors.primary
                          : (isWhite
                                ? Colors.grey.withValues(alpha: 0.4)
                                : Colors.transparent),
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: isWhite
                              ? CustomerAppColors.primary
                              : Colors.white,
                          size: 16.sp,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
