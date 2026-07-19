import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';

// Category Filter Bottom Sheet
class CategoryFilterBottomSheet extends StatefulWidget {
  final ShopProductsBloc productsBloc;
  final List<String> categories;

  const CategoryFilterBottomSheet({
    super.key,
    required this.productsBloc,
    required this.categories,
  });

  @override
  State<CategoryFilterBottomSheet> createState() =>
      _CategoryFilterBottomSheetState();
}

class _CategoryFilterBottomSheetState extends State<CategoryFilterBottomSheet> {
  @override
  void initState() {
    super.initState();
    widget.productsBloc.add(InitFilterSelectionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.productsBloc,
      child: BlocBuilder<ShopProductsBloc, ShopProductsState>(
        builder: (context, state) {
          final tempSelected = state.tempSelectedCategories;
          final isFiltered =
              tempSelected.isNotEmpty && !tempSelected.contains('All');

          return Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      'Filter by Category',
                      style: ShopAppTextStyles.heading3,
                    ),
                    if (isFiltered)
                      TextButton(
                        onPressed: () {
                          widget.productsBloc.add(
                            const FilterProductsByCategoryEvent(['All']),
                          );
                          Navigator.pop(context);
                        },
                        // Clear Filter
                        child: Text(
                          'Clear Filter',
                          style: TextStyle(
                            color: ShopAppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: widget.categories.map((category) {
                    final isSelected = tempSelected.contains(category);
                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: ShopAppColors.primary.withValues(
                        alpha: 0.2,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? ShopAppColors.primary
                            : Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        widget.productsBloc.add(
                          ToggleCategoryFilterEvent(category, selected),
                        );
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  // Button for Filter Products
                  child: ElevatedButton(
                    onPressed: () {
                      widget.productsBloc.add(
                        FilterProductsByCategoryEvent(tempSelected),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ShopAppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
