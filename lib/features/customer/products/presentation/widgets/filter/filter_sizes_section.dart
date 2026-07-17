import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_event.dart';
import 'package:street_cart/features/customer/products/presentation/utils/products_helper.dart';

// Filter Sizes Section
class FilterSizesSection extends StatelessWidget {
  final ProductFilterState state;
  final ProductFilterBloc bloc;

  const FilterSizesSection({
    super.key,
    required this.state,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    // Hide Section when no Specific Category is Selected
    final selectedCatsWithoutAll = state.selectedCategories
        .where((c) => c != 'All')
        .toList();
    if (selectedCatsWithoutAll.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: selectedCatsWithoutAll.map((cat) {
        // Get sizes for this category
        final sizesForCat = ProductsHelper.getSizesForCategory(state, cat);

        if (sizesForCat.isEmpty) return const SizedBox();

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
            // List Of Size Chips
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sortedSizes.length,
                itemBuilder: (context, index) {
                  final size = sortedSizes[index];
                  final isSelected = state.selectedSizes.contains(size);
                  return GestureDetector(
                    onTap: () => bloc.add(ToggleFilterSize(size)),
                    child: Container(
                      margin: EdgeInsets.only(right: 10.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? CustomerAppColors.primary
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          size,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
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
