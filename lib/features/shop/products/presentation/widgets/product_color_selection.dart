import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

class ProductColorSelection extends StatelessWidget {
  final List<String> availableColors;
  final List<String> selectedColors;
  final Function(String color, bool selected) onColorChipSelected;
  final VoidCallback onAddColorPressed;

  const ProductColorSelection({
    super.key,
    required this.availableColors,
    required this.selectedColors,
    required this.onColorChipSelected,
    required this.onAddColorPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colors',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: ShopAppColors.textSecondary,
          ),
        ),
        SizedBox(height: 8.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...availableColors.map((colorName) {
                final isSelected = selectedColors.contains(colorName);
                final color = ShopAppColors.getColorFromName(colorName);
                final isWhite = color.value == 0xFFFFFFFF;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: GestureDetector(
                    onTap: () => onColorChipSelected(colorName, !isSelected),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ShopAppColors.primary.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? ShopAppColors.primary
                              : Colors.grey[300]!,
                          width: 1.5.w,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 16.r,
                            height: 16.r,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isWhite
                                    ? Colors.grey[400]!
                                    : Colors.transparent,
                                width: 1.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            colorName,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? ShopAppColors.primary
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: ShopAppColors.primary,
                ),
                onPressed: onAddColorPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
