import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';

// Product Search TextField
class ProductSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final ShopProductsBloc productsBloc;

  const ProductSearchTextField({
    super.key,
    required this.controller,
    required this.productsBloc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search product...',
        hintStyle: TextStyle(
          color: isDark
              ? ShopAppColors.darkTextSecondary
              : ShopAppColors.textSecondary,
        ),
        border: InputBorder.none,
      ),
      style: TextStyle(
        fontSize: 16.sp,
        color: isDark
            ? ShopAppColors.darkTextPrimary
            : ShopAppColors.textPrimary,
      ),
      onChanged: (val) {
        productsBloc.add(SearchProductsEvent(val));
      },
    );
  }
}
