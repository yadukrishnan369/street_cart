import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_cubit.dart';

class FilterCategoriesSection extends StatelessWidget {
  final ProductFilterState state;
  final ProductFilterCubit cubit;

  const FilterCategoriesSection({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final filteredCats = state.allProducts
        .map((p) => p.category)
        .toSet()
        .where((c) => c.toLowerCase().contains(state.categoryQuery.toLowerCase()))
        .toList();

    final List<String> displayCats = ['All'];
    displayCats.addAll(filteredCats);

    final showSeeAllButton = displayCats.length > 5 && !state.showAllCategories && state.categoryQuery.isEmpty;
    final catsToRender = (state.showAllCategories || state.categoryQuery.isNotEmpty)
        ? displayCats
        : displayCats.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search categories...',
            prefixIcon: Icon(Icons.search, size: 20.sp, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
            contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          ),
          onChanged: (val) => cubit.updateCategoryQuery(val),
        ),
        SizedBox(height: 8.h),
        Container(
          constraints: BoxConstraints(maxHeight: 180.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: catsToRender.length,
            itemBuilder: (context, index) {
              final cat = catsToRender[index];
              final isSelected = state.selectedCategories.contains(cat);
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                title: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isSelected ? Colors.black87 : Colors.grey[700],
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () => cubit.toggleCategory(cat),
                  child: Container(
                    width: 22.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? CustomerAppColors.primary : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? CustomerAppColors.primary : Colors.grey[300]!,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 14.sp)
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
        if (state.categoryQuery.isNotEmpty && filteredCats.isEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              'No categories found matching "${state.categoryQuery}"',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
        if (showSeeAllButton) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => cubit.toggleShowAllCategories(true),
              icon: const Icon(Icons.keyboard_arrow_down),
              label: const Text('See All'),
              style: TextButton.styleFrom(
                foregroundColor: CustomerAppColors.primary,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
