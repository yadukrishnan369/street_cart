import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Product Category Dropdown
class ProductCategoryDropdown extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onChanged;

  const ProductCategoryDropdown({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Category',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: isDark
                ? ShopAppColors.darkTextSecondary
                : ShopAppColors.textSecondary,
          ),
        ),
        8.verticalSpace,
        // Dropdown for Select Product Category
        DropdownButtonFormField<String>(
          initialValue: selectedCategory,
          isExpanded: true,
          dropdownColor: isDark ? ShopAppColors.darkSurface : Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: isDark
                ? ShopAppColors.darkInputBackground
                : Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDark ? ShopAppColors.darkBorder : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDark ? ShopAppColors.darkBorder : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: ShopAppColors.primary),
            ),
            prefixIcon: Icon(
              Icons.category_outlined,
              color: ShopAppColors.primary,
              size: 20.sp,
            ),
          ),
          items: categories.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
