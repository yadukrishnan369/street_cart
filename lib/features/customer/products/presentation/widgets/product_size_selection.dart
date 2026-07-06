import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class ProductSizeSelection extends StatelessWidget {
  final List<String> sizes;
  final String? selectedSize;

  final Map<String, int> sizeStock;

  final ValueChanged<String> onSizeSelected;

  const ProductSizeSelection({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
    this.sizeStock = const {},
  });

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Size',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: CustomerAppColors.textPrimary,
              ),
            ),
            Text(
              'SIZE CHART',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: CustomerAppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: sizes.map((size) {
              final isSelected = selectedSize == size;
              final qty = sizeStock.isNotEmpty ? (sizeStock[size] ?? 0) : null;
              final isOutOfStock = qty != null && qty == 0;

              return GestureDetector(
                onTap: isOutOfStock ? null : () => onSizeSelected(size),
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  constraints: BoxConstraints(minWidth: 48.w),
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: isOutOfStock
                        ? Colors.grey[100]
                        : (isSelected ? Colors.transparent : Colors.white),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? CustomerAppColors.primary
                          : (isOutOfStock
                                ? Colors.grey[200]!
                                : Colors.grey.withValues(alpha: 0.2)),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        size,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: isOutOfStock
                              ? Colors.grey[400]
                              : (isSelected
                                    ? CustomerAppColors.primary
                                    : CustomerAppColors.textPrimary),
                          decoration: isOutOfStock
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      // Show quantity badge if sizeStock provided
                      if (qty != null && !isOutOfStock && qty <= 5)
                        Text(
                          '$qty left',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.orange[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 8.h),
        // out-of-stock
        if (sizeStock.isNotEmpty && sizeStock.values.any((q) => q == 0))
          Text(
            'Strikethrough sizes are out of stock for this color.',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
