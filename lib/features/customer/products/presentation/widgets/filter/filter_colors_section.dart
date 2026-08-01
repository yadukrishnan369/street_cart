import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/product_filter_event.dart';

// Filter Colors Section
class FilterColorsSection extends StatelessWidget {
  final ProductFilterState state;
  final ProductFilterBloc bloc;

  const FilterColorsSection({
    super.key,
    required this.state,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    // Hide Section when no Colors are Available
    if (state.availableColors.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colors',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        // List Of Colors
        SizedBox(
          height: 48.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.availableColors.length,
            itemBuilder: (context, index) {
              final colorName = state.availableColors[index];
              final isSelected = state.selectedColors.contains(colorName);
              final color = ShopAppColors.getColorFromName(colorName);
              final isWhite = color.toARGB32() == 0xFFFFFFFF;
              return GestureDetector(
                onTap: () => bloc.add(ToggleFilterColor(colorName)),
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? CustomerAppColors.primary
                          : (isWhite ? Colors.grey[300]! : Colors.transparent),
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  // Check Icon for Selected Color
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: isWhite ? Colors.black87 : Colors.white,
                          size: 18.sp,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
