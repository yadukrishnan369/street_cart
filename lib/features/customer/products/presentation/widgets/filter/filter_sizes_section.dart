import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_cubit.dart';

class FilterSizesSection extends StatelessWidget {
  final ProductFilterState state;
  final ProductFilterCubit cubit;

  const FilterSizesSection({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCatsWithoutAll = state.selectedCategories.where((c) => c != 'All').toList();
    if (selectedCatsWithoutAll.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: selectedCatsWithoutAll.map((cat) {
        final Set<String> sizesForCat = {};
        final useAllColors = state.selectedColors.isEmpty;

        for (final p in state.allProducts) {
          if (p.category.toLowerCase() == cat.toLowerCase()) {
            if (useAllColors) {
              sizesForCat.addAll(p.allSizes);
            } else {
              for (final variant in p.variants) {
                if (state.selectedColors.contains(variant.colorName)) {
                  for (final entry in variant.sizes.entries) {
                    if (entry.value > 0) {
                      sizesForCat.add(entry.key);
                    }
                  }
                }
              }
              if (!p.hasVariants && p.colors.any((c) => state.selectedColors.contains(c))) {
                sizesForCat.addAll(p.allSizes);
              }
            }
          }
        }

        if (sizesForCat.isEmpty) {
          return const SizedBox();
        }

        final sortedSizes = sizesForCat.toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$cat Sizes',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sortedSizes.length,
                itemBuilder: (context, index) {
                  final size = sortedSizes[index];
                  final isSelected = state.selectedSizes.contains(size);
                  return GestureDetector(
                    onTap: () => cubit.toggleSize(size),
                    child: Container(
                      margin: EdgeInsets.only(right: 10.w),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected ? CustomerAppColors.primary : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          size,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 13.sp,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 18.h),
          ],
        );
      }).toList(),
    );
  }
}
