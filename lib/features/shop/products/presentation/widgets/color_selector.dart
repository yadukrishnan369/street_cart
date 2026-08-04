import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Color Selector
class ColorSelector extends StatelessWidget {
  final Map<String, String> availableColors;
  final String selectedColor;
  final ValueChanged<String> onSelected;

  const ColorSelector({
    super.key,
    required this.availableColors,
    required this.selectedColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (availableColors.isEmpty) {
      return Text(
        'No colors available.',
        style: TextStyle(fontSize: 12.sp, color: ShopAppColors.textSecondary),
      );
    }

    final colorNames = availableColors.keys.toList();
    final int half = (colorNames.length / 2).ceil();
    final List<String> row1Colors = colorNames.take(half).toList();
    final List<String> row2Colors = colorNames.skip(half).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Colors List row 1
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: row1Colors
                .map((colorName) => _buildColorChip(context, colorName))
                .toList(),
          ),
        ),
        if (row2Colors.isNotEmpty) ...[
          SizedBox(height: 10.h),
          // Colors List row 2
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: row2Colors
                  .map((colorName) => _buildColorChip(context, colorName))
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildColorChip(BuildContext context, String colorName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hexCode = availableColors[colorName] ?? '';
    final color = ShopAppColors.getColorFromName(
      hexCode.isNotEmpty ? hexCode : colorName,
    );
    final isSelected = colorName == selectedColor;
    final isWhite = color.toARGB32() == 0xFFFFFFFF;
    return GestureDetector(
      onTap: () => onSelected(colorName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ShopAppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08)
              : (isDark ? ShopAppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? ShopAppColors.primary
                : (isDark
                      ? ShopAppColors.darkBorder
                      : (isWhite ? Colors.grey[300]! : Colors.grey[200]!)),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ShopAppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
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
                  color: isWhite ? Colors.grey[400]! : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Color Name
            Text(
              colorName,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? ShopAppColors.primary
                    : (isDark
                          ? ShopAppColors.darkTextPrimary
                          : ShopAppColors.textPrimary),
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 6.w),
              Icon(
                Icons.check_circle_rounded,
                color: ShopAppColors.primary,
                size: 14.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
