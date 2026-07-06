import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_cubit.dart';

class FilterPriceSection extends StatelessWidget {
  final ProductFilterState state;
  final ProductFilterCubit cubit;
  final TextEditingController minPriceController;
  final TextEditingController maxPriceController;

  const FilterPriceSection({
    super.key,
    required this.state,
    required this.cubit,
    required this.minPriceController,
    required this.maxPriceController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Price Range',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              '₹${state.minPrice.round()} - ₹${state.maxPrice.round()}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: CustomerAppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        RangeSlider(
          values: RangeValues(state.minPrice, state.maxPrice),
          min: state.absoluteMinPrice,
          max: state.absoluteMaxPrice,
          divisions: state.absoluteMaxPrice - state.absoluteMinPrice > 0
              ? (state.absoluteMaxPrice - state.absoluteMinPrice).round()
              : 1,
          activeColor: CustomerAppColors.primary,
          inactiveColor: Colors.grey[200],
          onChanged: (values) => cubit.updatePriceRange(values.start, values.end),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Min Price',
                  prefixText: '₹',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                ),
                onChanged: (val) {
                  final double? parsed = double.tryParse(val);
                  if (parsed != null) {
                    cubit.updatePriceRange(parsed, state.maxPrice);
                  }
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: TextField(
                controller: maxPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Max Price',
                  prefixText: '₹',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                ),
                onChanged: (val) {
                  final double? parsed = double.tryParse(val);
                  if (parsed != null) {
                    cubit.updatePriceRange(state.minPrice, parsed);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
