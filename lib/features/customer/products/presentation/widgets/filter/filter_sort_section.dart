import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_event.dart';

// Filter Sort Section
class FilterSortSection extends StatelessWidget {
  final String selectedSort;
  final ProductFilterBloc bloc;

  const FilterSortSection({
    super.key,
    required this.selectedSort,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        // Sort Chips
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildSortChip('Newest'),
            _buildSortChip('Popularity'),
            _buildSortChip('Price: Low to High'),
            _buildSortChip('Price: High to Low'),
          ],
        ),
      ],
    );
  }

  // Renders single sort chip
  Widget _buildSortChip(String label) {
    final isSelected = selectedSort == label;
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return GestureDetector(
          onTap: () => bloc.add(UpdateFilterSort(label)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? CustomerAppColors.primary
                  : (isDark ? const Color(0xFF2D2D2D) : Colors.grey[100]),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.black87),
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
