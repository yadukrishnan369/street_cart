import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/auth/presentation/pages/login_page.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_bloc.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_event.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_state.dart';
import 'package:street_cart/features/customer/cart/presentation/pages/cart_page.dart';
import 'package:street_cart/features/customer/cart/presentation/utils/cart_helper.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_bloc.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_state.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/cart/presentation/pages/checkout_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Product Action Buttons
class ProductActionButtons extends StatelessWidget {
  final ProductModel product;
  final int availableQty;

  const ProductActionButtons({
    super.key,
    required this.product,
    this.availableQty = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Read Selected Variant
    final blocState = context.watch<CustomerProductsBloc>().state;
    final selectedColor = blocState is ProductDetailState
        ? blocState.selectedColor
        : null;
    final selectedSize = blocState is ProductDetailState
        ? blocState.selectedSize
        : null;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            final bool isInCart = CartHelper.isProductInCart(
              cartState: cartState,
              productId: product.id,
              selectedColor: selectedColor,
              selectedSize: selectedSize,
            );

            final bool isOutOfStock = availableQty <= 0;

            return Row(
              children: [
                Expanded(
                  child: _buildCartButton(
                    context,
                    isInCart: isInCart,
                    isOutOfStock: isOutOfStock,
                    selectedColor: selectedColor,
                    selectedSize: selectedSize,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isOutOfStock
                        ? null
                        : () {
                            // Check login
                            if (!CartHelper.isUserLoggedIn()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              );
                              return;
                            }
                            // Validate variants
                            final warning = CartHelper.validateProductVariants(
                              product: product,
                              selectedColor: selectedColor,
                              selectedSize: selectedSize,
                            );
                            if (warning != null) {
                              CustomSnackBar.show(
                                context,
                                message: warning,
                                isError: true,
                              );
                              return;
                            }
                            final itemId =
                                '${product.id}_${selectedSize ?? ""}_${selectedColor ?? ""}';
                            final buyNowItem = CartItem(
                              id: itemId,
                              productId: product.id,
                              productName: product.name,
                              productImage: (selectedColor != null)
                                  ? product
                                            .imagesForColor(selectedColor)
                                            .firstOrNull ??
                                        (product.displayImages.firstOrNull ??
                                            '')
                                  : (product.displayImages.firstOrNull ?? ''),
                              price:
                                  (product.offerPrice ?? product.originalPrice)
                                      .toDouble(),
                              quantity: 1,
                              selectedColor: selectedColor,
                              selectedSize: selectedSize,
                              shopId: product.shopId,
                              addedAt: DateTime.now(),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CheckoutPage(cartItems: [buyNowItem]),
                              ),
                            );
                          },
                    icon: const Icon(Icons.bolt, size: 18),
                    label: const Text('Buy Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomerAppColors.primary,
                      disabledBackgroundColor: Colors.grey[300],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCartButton(
    BuildContext context, {
    required bool isInCart,
    required bool isOutOfStock,
    String? selectedColor,
    String? selectedSize,
  }) {
    if (isOutOfStock) {
      return OutlinedButton.icon(
        onPressed: null,
        icon: Icon(Icons.remove_shopping_cart, color: Colors.grey[400]),
        label: Text('Out of Stock', style: TextStyle(color: Colors.grey[400])),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[300]!),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }

    if (isInCart) {
      // Go to Cart
      final Color yellowColor = const Color(0xFFF59E0B);
      return ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartPage()),
          );
        },
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
        label: const Text(
          'Go to Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: yellowColor,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }

    // Default Add to Cart state
    return OutlinedButton.icon(
      onPressed: () async {
        // Check if logged in
        if (!CartHelper.isUserLoggedIn()) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
          return;
        }

        // Validate variants
        final warning = CartHelper.validateProductVariants(
          product: product,
          selectedColor: selectedColor,
          selectedSize: selectedSize,
        );
        if (warning != null) {
          CustomSnackBar.show(context, message: warning, isError: true);
          return;
        }

        // Add to Cart
        context.read<CartBloc>().add(
          AddProductToCart(
            product: product,
            selectedColor: selectedColor,
            selectedSize: selectedSize,
          ),
        );

        if (context.mounted) {
          CustomSnackBar.show(context, message: 'Product added to cart.');
        }
      },
      icon: const Icon(
        Icons.shopping_cart_outlined,
        color: CustomerAppColors.primary,
      ),
      label: const Text(
        'Add to Cart',
        style: TextStyle(
          color: CustomerAppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: CustomerAppColors.primary,
        side: const BorderSide(color: CustomerAppColors.primary),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
