import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';

// Product Detail Sizes Section
class ProductDetailSizesSection extends StatelessWidget {
  final ProductModel product;
  final ShopProductsState uiState;

  const ProductDetailSizesSection({
    super.key,
    required this.product,
    required this.uiState,
  });

  @override
  Widget build(BuildContext context) {
    if (product.allSizes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Available Sizes (Standard: ${product.sizeStandard})',
          style: ShopAppTextStyles.bodyMediumBold,
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: product.allSizes.map((size) {
            final isSelected = uiState.selectedSize == size;
            return GestureDetector(
              onTap: () {
                context.read<ShopProductsBloc>().add(
                  SelectSizeEvent(isSelected ? null : size),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? ShopAppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.grey[300]!,
                  ),
                ),
                // Size
                child: Text(
                  size,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : ShopAppColors.primary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
