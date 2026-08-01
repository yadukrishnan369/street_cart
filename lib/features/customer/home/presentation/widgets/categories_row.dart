import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Categories Row
class CategoriesRow extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoriesRow({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final displayCategories = ['All', ...categories.where((c) => c != 'All')];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: displayCategories.map((category) {
          final isSelected = category == selectedCategory;
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: InkWell(
              onTap: () => onCategorySelected(category),
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? CustomerAppColors.primary
                      : theme.cardColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark
                              ? CustomerAppColors.darkBorder
                              : Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? CustomerAppColors.darkTextPrimary
                              : CustomerAppColors.textPrimary),
                    fontSize: 14.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
