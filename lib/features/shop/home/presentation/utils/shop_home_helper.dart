import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/home/presentation/widgets/profile_completion_modal.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';
import 'package:street_cart/features/shop/profile/presentation/pages/edit_shop_profile_page.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/pages/add_edit_product_page.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/shop/orders/presentation/pages/shop_orders_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_order_status.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';

class ShopHomeHelper {
  // Filter Specific Shop Orders
  static List<OrderModel> getDisplayOrders({
    required List<OrderModel> allOrders,
    required String shopId,
    int limit = 4,
  }) {
    final filtered = allOrders.where((o) {
      final hasShopItem = o.items.any((i) => i.shopId == shopId);
      final isNew =
          ShopOrderStatus.fromString(o.status) == ShopOrderStatus.placed;
      return hasShopItem && isNew;
    }).toList();

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered.take(limit).toList();
  }

  // Get the specific Order items datas
  static Map<String, dynamic> getOrderItemUIData({
    required OrderModel order,
    required String shopId,
  }) {
    final shopItems = order.items.where((i) => i.shopId == shopId).toList();
    if (shopItems.isEmpty) return const {};

    final firstItem = shopItems.first;
    final totalAmount = shopItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final paymentMethodLabel = ShopOrdersHelper.getDisplayPaymentMethod(
      order.paymentMethod,
    );
    final bool isCOD = paymentMethodLabel == 'COD';
    final badgeColor = isCOD
        ? const Color(0xFF0F766E)
        : const Color(0xFF5E5CE6);

    final String displayName = shopItems.length > 1
        ? '${firstItem.productName} + ${shopItems.length - 1} more'
        : firstItem.productName;

    return {
      'shopItems': shopItems,
      'totalAmount': totalAmount,
      'paymentMethodLabel': paymentMethodLabel,
      'badgeColor': badgeColor,
      'displayName': displayName,
      'productImage': firstItem.productImage,
    };
  }

  // Show Profile Completion Modal
  static void showProfileCompletionDialog(
    BuildContext context,
    ShopProfileModel? profile,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ProfileCompletionModal(
        onCompleteNow: () {
          Navigator.pop(dialogContext);
          if (profile != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => sl<ShopProfileBloc>(),
                  child: EditShopProfilePage(profile: profile),
                ),
              ),
            );
          } else {
            CustomSnackBar.show(
              context,
              message: 'Loading profile details, please try again in a moment.',
            );
          }
        },
        onMaybeLater: () => Navigator.pop(dialogContext),
      ),
    );
  }

  // Show Logout Confimation
  static void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationModal(
        title: 'Logout',
        content: 'Are you sure you want to logout from your shop account?',
        confirmText: 'Yes, Logout',
        confirmColor: ShopAppColors.error,
        onConfirm: () {
          Navigator.pop(context);
          context.read<ShopAuthBloc>().add(ShopLogoutRequested());
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  // Navigate to Add Product page
  static void onAddProductTap(BuildContext context, String shopId) {
    final productsBloc = sl<ShopProductsBloc>();
    productsBloc.add(LoadProductConfigEvent(shopId));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddEditProductPage(shopId: shopId, productsBloc: productsBloc),
      ),
    );
  }

  // Navigate to Edit Profile Page
  static void onEditProfileTap(BuildContext context, ShopProfileModel profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => sl<ShopProfileBloc>(),
          child: EditShopProfilePage(profile: profile),
        ),
      ),
    );
  }

  // Navigate to Orders Page
  static void onViewOrdersTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ShopOrdersPage()),
    );
  }

  // Calculate total earnings from all delivered orders
  static double calculateTotalSales({
    required List<OrderModel> orders,
    required String shopId,
  }) {
    double total = 0.0;
    for (final order in orders) {
      final status = order.status.toLowerCase();
      final isReturned =
          order.returnStatus != null && order.returnStatus!.isNotEmpty;
      if (status == 'delivered' && !isReturned) {
        for (final item in order.items) {
          if (item.shopId == shopId) {
            total += item.price * item.quantity;
          }
        }
      }
    }
    return total;
  }

  // Calculate weekly earnings
  static double calculateWeeklySales({
    required List<OrderModel> orders,
    required String shopId,
  }) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    double total = 0.0;
    for (final order in orders) {
      final status = order.status.toLowerCase();
      final isReturned =
          order.returnStatus != null && order.returnStatus!.isNotEmpty;
      final isInRange =
          order.createdAt.isAfter(weekAgo) && order.createdAt.isBefore(now);
      if (status == 'delivered' && !isReturned && isInRange) {
        for (final item in order.items) {
          if (item.shopId == shopId) {
            total += item.price * item.quantity;
          }
        }
      }
    }
    return total;
  }

  // Calculate today earnings
  static double calculateTodaySales({
    required List<OrderModel> orders,
    required String shopId,
  }) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    double total = 0.0;
    for (final order in orders) {
      final status = order.status.toLowerCase();
      final isReturned =
          order.returnStatus != null && order.returnStatus!.isNotEmpty;
      final isToday =
          order.createdAt.isAfter(todayStart) &&
          order.createdAt.isBefore(todayEnd);
      if (status == 'delivered' && !isReturned && isToday) {
        for (final item in order.items) {
          if (item.shopId == shopId) {
            total += item.price * item.quantity;
          }
        }
      }
    }
    return total;
  }
}
