import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_event.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_state.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class ProductWishlistButton extends StatelessWidget {
  final ProductModel product;
  final ShopProfileModel shop;
  final String? selectedColor;
  final String? selectedSize;

  const ProductWishlistButton({
    super.key,
    required this.product,
    required this.shop,
    this.selectedColor,
    this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishlistBloc, WishlistState>(
      builder: (context, wishlistState) {
        final isWishlisted =
            wishlistState is WishlistLoaded &&
            wishlistState.isWishlisted(product.id);
        return IconButton(
          icon: Icon(
            isWishlisted ? Icons.favorite : Icons.favorite_border,
            color: isWishlisted
                ? Colors.red
                : CustomerAppColors.textPrimary,
          ),
          onPressed: () {
            if (isWishlisted) {
              context.read<WishlistBloc>().add(
                RemoveProductFromWishlist(productId: product.id),
              );
              CustomSnackBar.show(
                context,
                message: 'Removed from wishlist',
              );
            } else {
              context.read<WishlistBloc>().add(
                AddProductToWishlist(
                  product: product,
                  shop: shop,
                  selectedColor: selectedColor,
                  selectedSize: selectedSize,
                ),
              );
              CustomSnackBar.show(
                context,
                message: 'Added to wishlist',
              );
            }
          },
        );
      },
    );
  }
}
