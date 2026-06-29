import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

class ProductSizeSelection extends StatelessWidget {
  final String selectedSizeStandard;
  final List<String> sizeStandards;
  final List<String> availableSizes;
  final List<String> selectedSizes;
  final ValueChanged<String?> onSizeStandardChanged;
  final Function(String size, bool selected) onSizeChipSelected;
  final VoidCallback onAddSizePressed;

  const ProductSizeSelection({
    super.key,
    required this.selectedSizeStandard,
    required this.sizeStandards,
    required this.availableSizes,
    required this.selectedSizes,
    required this.onSizeStandardChanged,
    required this.onSizeChipSelected,
    required this.onAddSizePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Size Standard',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: ShopAppColors.textSecondary,
          ),
        ),
        8.verticalSpace,
        DropdownButtonFormField<String>(
          value: selectedSizeStandard,
          isExpanded: true,
          dropdownColor: Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: ShopAppColors.primary,
              ),
            ),
            prefixIcon: Icon(
              Icons.straighten_outlined,
              color: ShopAppColors.primary,
              size: 20.sp,
            ),
          ),
          items: sizeStandards.map((std) {
            return DropdownMenuItem(
              value: std,
              child: Text(
                std,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
          onChanged: onSizeStandardChanged,
        ),
        SizedBox(height: 16.h),

        // Size Chips Selection
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...availableSizes.map((size) {
                final isSelected = selectedSizes.contains(size);
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ChoiceChip(
                    label: Text(size),
                    selected: isSelected,
                    selectedColor: ShopAppColors.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? ShopAppColors.primary : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) => onSizeChipSelected(size, selected),
                  ),
                );
              }),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: ShopAppColors.primary,
                ),
                onPressed: onAddSizePressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
