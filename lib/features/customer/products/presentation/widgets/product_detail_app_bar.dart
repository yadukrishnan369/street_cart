import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/products/presentation/widgets/product_wishlist_button.dart';

// Product Details page App bar
class ProductDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final ProductModel product;
  final ShopProfileModel shop;
  final String? selectedColor;
  final String? selectedSize;

  const ProductDetailAppBar({
    super.key,
    required this.product,
    required this.shop,
    this.selectedColor,
    this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomerAppColors.surface,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: CustomerAppColors.textPrimary,
        ),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomePage(),
                transitionDuration: Duration.zero,
              ),
            );
          }
        },
      ),
      centerTitle: true,
      // Page Header
      title: Text(
        'Product Details',
        style: TextStyle(
          color: CustomerAppColors.textPrimary,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      // WishList Button
      actions: [
        ProductWishlistButton(
          product: product,
          shop: shop,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
