import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_state.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/get_product_by_id.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/get_shop_by_id.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_bloc.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_event.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_product_detail_page.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/core/navigation/page_transitions.dart';

class CartHelper {
  static Timer? _scrollDebounceTimer;

  // Calculates total quantity of items
  static int calculateTotalItems(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Calculates subtotal price of items
  static double calculateSubtotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Calculates total amount
  static double calculateTotalAmount(double subtotal) {
    return subtotal;
  }

  // Validates if required product color/size are selected
  static String? validateProductVariants({
    required ProductModel product,
    String? selectedColor,
    String? selectedSize,
  }) {
    if (product.allColors.isNotEmpty && selectedColor == null) {
      return 'Please select a color';
    }
    if (product.allSizes.isNotEmpty && selectedSize == null) {
      return 'Please select a size';
    }
    return null;
  }

  // Shows the Clear Cart Confirmation dialog
  static void showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomAlertDialog(
        title: 'Clear Cart',
        content: 'Are you sure you want to remove all items from your cart?',
        primaryActionLabel: 'Clear',
        primaryActionColor: CustomerAppColors.error,
        secondaryActionLabel: 'Cancel',
        icon: Icons.delete_sweep_outlined,
        iconColor: CustomerAppColors.error,
        onPrimaryAction: () {
          context.read<CartBloc>().add(ClearAllCart());
          Navigator.pop(dialogContext);
        },
        onSecondaryAction: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // Shows the Remove Cart Item confirmation dialog
  static void showDeleteDialog(BuildContext context, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomAlertDialog(
        title: 'Delete Item',
        content: 'Are you sure you want to remove this item from your cart?',
        primaryActionLabel: 'Delete',
        primaryActionColor: CustomerAppColors.error,
        secondaryActionLabel: 'Cancel',
        icon: Icons.delete_outline,
        iconColor: CustomerAppColors.error,
        onPrimaryAction: () {
          onDelete();
          Navigator.pop(dialogContext);
        },
        onSecondaryAction: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // Fetches Product and Shop details
  static Future<void> navigateToProductDetail(
    BuildContext context,
    CartItem item,
  ) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final product = await sl<GetProductById>().call(item.productId);
      final shop = await sl<GetShopById>().call(item.shopId);

      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading dialog
      }

      if (context.mounted) {
        Navigator.push(
          context,
          AppPageTransitions.slide(
            CustomerProductDetailPage(
              product: product,
              shop: shop,
              initialColor: item.selectedColor,
              initialSize: item.selectedSize,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading dialog
        CustomSnackBar.show(
          context,
          message: 'Error fetching product details: $e',
          isError: true,
        );
      }
    }
  }

  // Checks if a product with selected variants is already in the cart
  static bool isProductInCart({
    required CartState cartState,
    required String productId,
    String? selectedColor,
    String? selectedSize,
  }) {
    if (cartState is CartLoaded) {
      final itemId =
          '${productId}_${selectedSize ?? ""}_${selectedColor ?? ""}';
      return cartState.items.any((item) => item.id == itemId);
    }
    return false;
  }

  // Checks if the customer is logged in
  static bool isUserLoggedIn() {
    return sl<FirebaseAuth>().currentUser != null;
  }

  // Handles scroll events to toggle order summary visibility
  static void handleScroll(
    BuildContext context,
    ScrollController scrollController,
    CartLoaded currentState,
  ) {
    if (!scrollController.hasClients) return;

    if (scrollController.offset <= 0 ||
        scrollController.position.maxScrollExtent <= 0) {
      _scrollDebounceTimer?.cancel();
      if (!currentState.isSummaryVisible) {
        context.read<CartBloc>().add(
          const ToggleSummaryVisibility(isVisible: true),
        );
      }
      return;
    }

    if (currentState.isSummaryVisible) {
      context.read<CartBloc>().add(
        const ToggleSummaryVisibility(isVisible: false),
      );
    }

    // shows the summary card back after 2 seconds
    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = Timer(const Duration(seconds: 3), () {
      if (context.mounted) {
        final state = context.read<CartBloc>().state;
        if (state is CartLoaded && !state.isSummaryVisible) {
          context.read<CartBloc>().add(
            const ToggleSummaryVisibility(isVisible: true),
          );
        }
      }
    });
  }
}
