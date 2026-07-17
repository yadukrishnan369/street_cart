import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_event.dart';

// Filter Rating Section
class FilterRatingSection extends StatelessWidget {
  final String? selectedRating;
  final ProductFilterBloc bloc;

  const FilterRatingSection({
    super.key,
    required this.selectedRating,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        // List Of Rating Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildRatingChip('4★ & above'),
              SizedBox(width: 8.w),
              _buildRatingChip('3★ & above'),
              SizedBox(width: 8.w),
              _buildRatingChip('2★ & above'),
              SizedBox(width: 8.w),
              _buildRatingChip('1★ & above'),
            ],
          ),
        ),
      ],
    );
  }

  // Renders single rating chip
  Widget _buildRatingChip(String label) {
    final isSelected = selectedRating == label;
    return GestureDetector(
      onTap: () => bloc.add(ToggleFilterRating(label)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? CustomerAppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.star : Icons.star_border,
              size: 16.sp,
              color: isSelected ? Colors.white : Colors.amber,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
