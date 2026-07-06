import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';

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
  late List<String> selectedCategories;

  @override
  void initState() {
    super.initState();
    final currentState = widget.productsBloc.state;
    if (currentState is ShopProductsLoaded) {
      selectedCategories = List.from(currentState.selectedCategories);
    } else {
      selectedCategories = ['All'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFiltered =
        selectedCategories.isNotEmpty && !selectedCategories.contains('All');

    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter by Category', style: ShopAppTextStyles.heading3),
              if (isFiltered)
                TextButton(
                  onPressed: () {
                    widget.productsBloc.add(
                      const FilterProductsByCategoryEvent(['All']),
                    );
                    Navigator.pop(context);
                  },
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
              final isSelected = selectedCategories.contains(category);
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                selectedColor: ShopAppColors.primary.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected ? ShopAppColors.primary : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) {
                  setState(() {
                    if (category == 'All') {
                      selectedCategories = ['All'];
                    } else {
                      selectedCategories.remove('All');
                      if (selected) {
                        selectedCategories.add(category);
                      } else {
                        selectedCategories.remove(category);
                      }
                      if (selectedCategories.isEmpty) {
                        selectedCategories.add('All');
                      }
                    }
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                widget.productsBloc.add(
                  FilterProductsByCategoryEvent(selectedCategories),
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
  }
}
