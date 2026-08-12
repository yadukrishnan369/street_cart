import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/pages/add_edit_product_page.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

// Product Detail Edit Button
class ProductDetailEditButton extends StatelessWidget {
  final ProductModel product;
  final String shopId;
  final ShopProductsBloc productsBloc;

  const ProductDetailEditButton({
    super.key,
    required this.product,
    required this.shopId,
    required this.productsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ShopAppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        onPressed: () {
          // Navigate to Add Edit Product Page
          Navigator.push(
            context,
            AppPageTransitions.slide(
              AddEditProductPage(
                shopId: shopId,
                product: product,
                productsBloc: productsBloc,
              ),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              'Edit Product',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
