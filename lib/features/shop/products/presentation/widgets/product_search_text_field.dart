import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';

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
    return TextField(
      controller: controller,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search product...',
        border: InputBorder.none,
      ),
      style: TextStyle(fontSize: 16.sp),
      onChanged: (val) {
        productsBloc.add(SearchProductsEvent(val));
      },
    );
  }
}
