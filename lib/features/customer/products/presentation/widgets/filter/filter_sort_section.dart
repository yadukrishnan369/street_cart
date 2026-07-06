import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_cubit.dart';

class FilterSortSection extends StatelessWidget {
  final String selectedSort;
  final ProductFilterCubit cubit;

  const FilterSortSection({
    super.key,
    required this.selectedSort,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildSortChip('Newest', selectedSort),
            _buildSortChip('Popularity', selectedSort),
            _buildSortChip('Price: Low to High', selectedSort),
            _buildSortChip('Price: High to Low', selectedSort),
          ],
        ),
      ],
    );
  }

  Widget _buildSortChip(String label, String selectedSort) {
    final isSelected = selectedSort == label;
    return GestureDetector(
      onTap: () => cubit.updateSort(label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? CustomerAppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
