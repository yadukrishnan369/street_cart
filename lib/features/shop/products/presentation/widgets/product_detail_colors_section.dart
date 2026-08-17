import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';

// Product Detail Colors Section
class ProductDetailColorsSection extends StatelessWidget {
  final ProductModel product;
  final ShopProductsState uiState;

  const ProductDetailColorsSection({
    super.key,
    required this.product,
    required this.uiState,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (product.allColors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'Available Colors',
          style: isDark
              ? ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: ShopAppColors.darkTextPrimary,
                )
              : ShopAppTextStyles.bodyMediumBold,
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: product.allColors.map((colorName) {
            final hexCode = product.colorsWithHex[colorName] ?? '';
            final color = ShopAppColors.getColorFromName(
              hexCode.isNotEmpty ? hexCode : colorName,
            );
            final isWhite = color.toARGB32() == 0xFFFFFFFF;
            final isSelected = uiState.selectedColor == colorName;
            return GestureDetector(
              onTap: () {
                context.read<ShopProductsBloc>().add(
                  SelectColorEvent(isSelected ? null : colorName),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ShopAppColors.primary.withValues(
                          alpha: isDark ? 0.2 : 0.08,
                        )
                      : (isDark ? ShopAppColors.darkSurface : Colors.white),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: isSelected
                        ? ShopAppColors.primary
                        : (isDark
                              ? ShopAppColors.darkBorder
                              : Colors.grey[300]!),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.02,
                      ),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14.r,
                      height: 14.r,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isWhite
                              ? Colors.grey[400]!
                              : Colors.transparent,
                          width: 1.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Color Name
                    Text(
                      colorName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? ShopAppColors.primary
                            : (isDark
                                  ? ShopAppColors.darkTextPrimary
                                  : ShopAppColors.textPrimary),
                      ),
                    ),
                  ],
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
