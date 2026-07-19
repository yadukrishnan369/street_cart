import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_order_status.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';

class ShopOrdersHelper {
  static List<OrderModel> filterOrders(List<OrderModel> orders, int tabIndex) {
    switch (tabIndex) {
      case 0: // NEW
        return orders.where((o) {
          final s = ShopOrderStatus.fromString(o.status);
          return s == ShopOrderStatus.placed;
        }).toList();
      case 1: // PROCESS
        return orders
            .where(
              (o) =>
                  ShopOrderStatus.fromString(o.status) ==
                  ShopOrderStatus.processing,
            )
            .toList();
      case 2: // SHIPPED
        return orders.where((o) {
          final s = ShopOrderStatus.fromString(o.status);
          return s == ShopOrderStatus.shipped;
        }).toList();
      case 3: // DONE
        return orders
            .where(
              (o) =>
                  ShopOrderStatus.fromString(o.status) ==
                  ShopOrderStatus.delivered,
            )
            .toList();
      case 4: // RETURNED
        return orders.where((o) {
          final s = ShopOrderStatus.fromString(o.status);
          return s == ShopOrderStatus.returned ||
              s == ShopOrderStatus.cancelled ||
              s == ShopOrderStatus.return_requested;
        }).toList();
      default:
        return [];
    }
  }

  // Get Orders Count
  static int getCount(List<OrderModel> orders, int tabIndex) {
    return filterOrders(orders, tabIndex).length;
  }

  // Get Time
  static String getRelativeTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? 'min' : 'mins'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    }
  }

  // Get Selected Payment Method
  static String getDisplayPaymentMethod(String method) {
    final m = method.toLowerCase();
    if (m.contains('cod') || m.contains('cash')) {
      return 'COD';
    }
    if (m.contains('online') || m.contains('paid')) {
      return 'PAID';
    }
    return method.toUpperCase();
  }

  // Get Next Status Action Label
  static String? getNextStatusActionLabel(ShopOrderStatus currentStatus) {
    switch (currentStatus) {
      case ShopOrderStatus.placed:
        return 'Confirm Order';
      case ShopOrderStatus.processing:
        return 'Mark as Shipped';
      case ShopOrderStatus.shipped:
        return ' Mark as Delivered';
      default:
        return null;
    }
  }

  // Get Next Status
  static ShopOrderStatus? getNextStatus(ShopOrderStatus currentStatus) {
    switch (currentStatus) {
      case ShopOrderStatus.placed:
        return ShopOrderStatus.processing;
      case ShopOrderStatus.processing:
        return ShopOrderStatus.shipped;
      case ShopOrderStatus.shipped:
        return ShopOrderStatus.delivered;
      default:
        return null;
    }
  }

  // Get Order ID
  static String getOrderIdPrefix(String orderId) {
    final length = orderId.length;
    final prefix = orderId.substring(0, length.clamp(0, 5));
    return prefix.toUpperCase();
  }

  // Status Change Confirmation Modal
  static void showStatusChangeConfirmation({
    required BuildContext context,
    required String statusLabel,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationModal(
        title: 'Confirm Action',
        content: 'Are you sure you want to proceed with "$statusLabel"?',
        confirmText: 'Yes, Proceed',
        cancelText: 'Cancel',
        confirmColor: ShopAppColors.primary,
        onConfirm: () {
          Navigator.pop(ctx);
          onConfirm();
        },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }

  // Filtering items in an order of shop, calculates total amount
  static Map<String, dynamic> getShopOrderCardData({
    required OrderModel order,
    required String shopId,
  }) {
    final shopItems = order.items
        .where((item) => item.shopId == shopId)
        .toList();
    if (shopItems.isEmpty) return const {};

    final firstItem = shopItems.first;
    final totalAmount = shopItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return {
      'shopItems': shopItems,
      'firstItem': firstItem,
      'totalAmount': totalAmount,
    };
  }

  // Calculates total price, commission, commission percentage, final earnings and payment label
  static Map<String, dynamic> getItemSummaryCardData({
    required OrderModel order,
    required String shopId,
  }) {
    final shopItems = order.items
        .where((item) => item.shopId == shopId)
        .toList();
    if (shopItems.isEmpty) return const {};

    final totalAmount = shopItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final commission = shopItems.fold<double>(
      0.0,
      (sum, item) => sum + item.adminCommission,
    );

    final commissionPercentage = totalAmount > 0
        ? (commission / totalAmount) * 100
        : 0.0;

    final finalEarnings = totalAmount - commission;
    final paymentLabel = getDisplayPaymentMethod(order.paymentMethod);

    return {
      'shopItems': shopItems,
      'totalAmount': totalAmount,
      'commission': commission,
      'commissionPercentage': commissionPercentage,
      'finalEarnings': finalEarnings,
      'paymentLabel': paymentLabel,
    };
  }
}
