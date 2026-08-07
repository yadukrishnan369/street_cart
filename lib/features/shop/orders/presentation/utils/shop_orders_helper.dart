import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_order_status.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';

class ShopOrdersHelper {
  // Filter Orders
  static List<OrderModel> filterOrders(
    List<OrderModel> orders,
    int tabIndex,
    String shopId,
  ) {
    switch (tabIndex) {
      case 0: // NEW
        return orders.where((o) {
          final s = ShopOrderStatus.fromString(o.status);
          final hasActiveShopItem = o.items.any(
            (item) => item.shopId == shopId && item.status != 'cancelled',
          );
          return s == ShopOrderStatus.placed && hasActiveShopItem;
        }).toList();
      case 1: // PROCESS
        return orders
            .where(
              (o) =>
                  ShopOrderStatus.fromString(o.status) ==
                      ShopOrderStatus.processing &&
                  o.items.any(
                    (item) =>
                        item.shopId == shopId && item.status != 'cancelled',
                  ),
            )
            .toList();
      case 2: // SHIPPED
        return orders.where((o) {
          final s = ShopOrderStatus.fromString(o.status);
          final hasActiveShopItem = o.items.any(
            (item) => item.shopId == shopId && item.status != 'cancelled',
          );
          return s == ShopOrderStatus.shipped && hasActiveShopItem;
        }).toList();
      case 3: // DONE
        return orders.where((o) {
          final isDelivered =
              ShopOrderStatus.fromString(o.status) == ShopOrderStatus.delivered;
          if (!isDelivered) return false;
          final hasCompletedItem = o.items.any(
            (item) =>
                item.shopId == shopId &&
                item.status != 'cancelled' &&
                (item.returnStatus == null || item.returnStatus!.isEmpty),
          );
          return hasCompletedItem;
        }).toList();
      case 4: // CANCELLED
        final cancelledOrders = orders.where((o) {
          final hasCancelledItem = o.items.any(
            (item) => item.shopId == shopId && item.status == 'cancelled',
          );
          return o.status.toLowerCase() == 'cancelled' || hasCancelledItem;
        }).toList();
        cancelledOrders.sort((a, b) {
          final isAPending =
              a.refundStatus == 'pending' ||
              a.items.any(
                (item) =>
                    item.shopId == shopId &&
                    item.status == 'cancelled' &&
                    item.refundStatus == 'pending',
              );
          final isBPending =
              b.refundStatus == 'pending' ||
              b.items.any(
                (item) =>
                    item.shopId == shopId &&
                    item.status == 'cancelled' &&
                    item.refundStatus == 'pending',
              );
          if (isAPending && !isBPending) return -1;
          if (!isAPending && isBPending) return 1;
          final timeA = a.cancelledAt ?? a.createdAt;
          final timeB = b.cancelledAt ?? b.createdAt;
          return timeB.compareTo(timeA);
        });
        return cancelledOrders;
      case 5: // RETURNED
        final returnedOrders = orders.where((o) {
          final hasReturnedItem = o.items.any(
            (item) =>
                item.shopId == shopId &&
                item.returnStatus != null &&
                item.returnStatus!.isNotEmpty,
          );
          return hasReturnedItem;
        }).toList();
        returnedOrders.sort((a, b) {
          final statusOrder = {
            'return_requested': 0,
            'return_confirmed': 1,
            'return_picked': 2,
          };
          final valA = statusOrder[a.returnStatus?.toLowerCase()] ?? 99;
          final valB = statusOrder[b.returnStatus?.toLowerCase()] ?? 99;
          if (valA != valB) {
            return valA.compareTo(valB);
          }
          final timeA = a.returnedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final timeB = b.returnedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return timeB.compareTo(timeA);
        });
        return returnedOrders;
      default:
        return [];
    }
  }

  // Get Orders Count
  static int getCount(List<OrderModel> orders, int tabIndex, String shopId) {
    return filterOrders(orders, tabIndex, shopId).length;
  }

  // Get Order Time based on status
  static DateTime getOrderTimeForStatus(OrderModel order) {
    if (order.returnStatus != null && order.returnStatus!.isNotEmpty) {
      final rStatus = order.returnStatus!.toLowerCase();
      if (rStatus == 'return_requested') {
        return order.returnedAt ?? order.createdAt;
      } else if (rStatus == 'return_confirmed') {
        return order.returnConfirmedAt ?? order.returnedAt ?? order.createdAt;
      } else if (rStatus == 'return_picked') {
        if (order.refundStatus == 'refunded') {
          return order.refundedAt ??
              order.returnPickedAt ??
              order.returnedAt ??
              order.createdAt;
        }
        return order.returnPickedAt ?? order.returnedAt ?? order.createdAt;
      }
      return order.returnedAt ?? order.createdAt;
    }
    final status = order.status.toLowerCase();
    if (status == 'cancelled') {
      return order.cancelledAt ?? order.createdAt;
    }
    if (status == 'delivered') {
      return order.deliveredAt ?? order.createdAt;
    }
    if (status == 'shipped' || status == 'packed') {
      return order.shippedAt ?? order.createdAt;
    }
    if (status == 'processing') {
      return order.confirmedAt ?? order.createdAt;
    }
    return order.createdAt;
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
        return 'Mark as Delivered';
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
    bool isCancelledView = false,
    bool isReturnedView = false,
  }) {
    final shopItems = order.items
        .where((item) => item.shopId == shopId)
        .toList();
    if (shopItems.isEmpty) return const {};

    final activeItems = shopItems
        .where(
          (item) =>
              item.status != 'cancelled' &&
              (item.returnStatus == null || item.returnStatus!.isEmpty),
        )
        .toList();
    final cancelledItems = shopItems
        .where((item) => item.status == 'cancelled')
        .toList();
    final returnedItems = shopItems
        .where(
          (item) => item.returnStatus != null && item.returnStatus!.isNotEmpty,
        )
        .toList();

    final List<OrderItemModel> displayItems;
    if (isReturnedView) {
      displayItems = returnedItems.isNotEmpty ? returnedItems : shopItems;
    } else if (isCancelledView || order.status.toLowerCase() == 'cancelled') {
      displayItems = cancelledItems.isNotEmpty ? cancelledItems : shopItems;
    } else {
      displayItems = activeItems.isNotEmpty ? activeItems : shopItems;
    }

    final firstItem = displayItems.first;
    final totalAmount = shopItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final displayItem = firstItem;

    final String productNameText = displayItems.length > 1
        ? '${firstItem.productName} + ${displayItems.length - 1} more'
        : firstItem.productName;

    final double cardTotalAmount;
    if (isReturnedView && returnedItems.isNotEmpty) {
      // For returned items - show pending-return amount
      final pendingReturnItems = returnedItems
          .where(
            (item) =>
                item.returnStatus == 'return_requested' ||
                item.returnStatus == 'return_confirmed',
          )
          .toList();
      cardTotalAmount = pendingReturnItems.isNotEmpty
          ? pendingReturnItems.fold<double>(
              0.0,
              (sum, item) => sum + (item.price * item.quantity),
            )
          : returnedItems.fold<double>(
              0.0,
              (sum, item) => sum + (item.price * item.quantity),
            );
    } else if (order.status.toLowerCase() == 'cancelled') {
      // Whole order cancelled-  show total of all shop items
      cardTotalAmount = totalAmount;
    } else if (isCancelledView && cancelledItems.isNotEmpty) {
      cardTotalAmount = cancelledItems.fold<double>(
        0.0,
        (sum, item) => sum + (item.price * item.quantity),
      );
    } else {
      cardTotalAmount = activeItems.fold<double>(
        0.0,
        (sum, item) => sum + (item.price * item.quantity),
      );
    }

    return {
      'shopItems': shopItems,
      'firstItem': displayItem,
      'totalAmount': cardTotalAmount,
      'productNameText': productNameText,
    };
  }

  // Calculates total price, commission, commission percentage, final earnings and payment label
  static Map<String, dynamic> getItemSummaryCardData({
    required OrderModel order,
    required String shopId,
    bool isCancelledView = false,
    bool isReturnedView = false,
  }) {
    final shopItems = order.items
        .where((item) => item.shopId == shopId)
        .toList();
    if (shopItems.isEmpty) return const {};

    final activeShopItems = shopItems
        .where(
          (item) =>
              item.status != 'cancelled' &&
              (item.returnStatus == null || item.returnStatus!.isEmpty),
        )
        .toList();

    final cancelledShopItems = shopItems
        .where((item) => item.status == 'cancelled')
        .toList();

    final returnedShopItems = shopItems
        .where(
          (item) => item.returnStatus != null && item.returnStatus!.isNotEmpty,
        )
        .toList();

    final List<OrderItemModel> displayItems;
    if (isReturnedView) {
      displayItems = returnedShopItems;
    } else if (isCancelledView || order.status.toLowerCase() == 'cancelled') {
      displayItems = cancelledShopItems.isNotEmpty
          ? cancelledShopItems
          : shopItems;
    } else {
      displayItems = activeShopItems;
    }

    final totalAmount = displayItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final commission = displayItems.fold<double>(
      0.0,
      (sum, item) => sum + item.adminCommission,
    );

    final commissionPercentage = totalAmount > 0
        ? (commission / totalAmount) * 100
        : 0.0;

    final finalEarnings = totalAmount - commission;
    final paymentLabel = getDisplayPaymentMethod(order.paymentMethod);

    return {
      'shopItems': displayItems,
      'totalAmount': totalAmount,
      'commission': commission,
      'commissionPercentage': commissionPercentage,
      'finalEarnings': finalEarnings,
      'paymentLabel': paymentLabel,
    };
  }

  // Calculates data for returned items card
  static Map<String, dynamic> getReturnedItemCardData({
    required OrderModel order,
    required String shopId,
  }) {
    final returnedItems = getReturnedItems(order: order, shopId: shopId);

    final paymentLabel = getDisplayPaymentMethod(order.paymentMethod);
    final badgeColor = paymentLabel == 'COD'
        ? ShopAppColors.warning
        : ShopAppColors.success;

    final activeItems = returnedItems
        .where(
          (item) =>
              item.returnStatus == 'return_requested' ||
              item.returnStatus == 'return_confirmed',
        )
        .toList();

    final totalAmount = activeItems.isNotEmpty
        ? activeItems.fold<double>(
            0.0,
            (sum, item) => sum + (item.price * item.quantity),
          )
        : returnedItems.fold<double>(
            0.0,
            (sum, item) => sum + (item.price * item.quantity),
          );

    return {
      'returnedItems': returnedItems,
      'paymentLabel': paymentLabel,
      'badgeColor': badgeColor,
      'totalAmount': totalAmount,
    };
  }

  // Get filtered list of returned items
  static List<OrderItemModel> getReturnedItems({
    required OrderModel order,
    required String shopId,
  }) {
    final returnedItems = order.items.where((item) {
      final hasReturnStatus =
          item.returnStatus != null && item.returnStatus!.isNotEmpty;
      return hasReturnStatus && item.shopId == shopId;
    }).toList();

    if (returnedItems.isEmpty) {
      final fallback = order.items.firstWhere(
        (item) => item.shopId == shopId,
        orElse: () => order.items.first,
      );
      returnedItems.add(fallback);
    }
    return returnedItems;
  }

  // Get status grouped list items for returned tab
  static List<dynamic> getReturnedOrdersListItems(
    List<OrderModel> filteredList,
  ) {
    final newRequests =
        filteredList
            .where((o) => o.returnStatus?.toLowerCase() == 'return_requested')
            .toList()
          ..sort(
            (a, b) =>
                getOrderTimeForStatus(b).compareTo(getOrderTimeForStatus(a)),
          );

    final confirmedReturns =
        filteredList
            .where((o) => o.returnStatus?.toLowerCase() == 'return_confirmed')
            .toList()
          ..sort(
            (a, b) =>
                getOrderTimeForStatus(b).compareTo(getOrderTimeForStatus(a)),
          );

    final pickedReturns =
        filteredList
            .where((o) => o.returnStatus?.toLowerCase() == 'return_picked')
            .toList()
          ..sort(
            (a, b) =>
                getOrderTimeForStatus(b).compareTo(getOrderTimeForStatus(a)),
          );

    final listItems = <dynamic>[];
    if (newRequests.isNotEmpty) {
      listItems.add('New Request');
      listItems.addAll(newRequests);
    }
    if (confirmedReturns.isNotEmpty) {
      listItems.add('Confirmed Return');
      listItems.addAll(confirmedReturns);
    }
    if (pickedReturns.isNotEmpty) {
      listItems.add('Picked');
      listItems.addAll(pickedReturns);
    }
    return listItems;
  }

  // Get currently updated order
  static OrderModel getCurrentOrder({
    required ShopOrdersState state,
    required OrderModel fallbackOrder,
  }) {
    if (state.status == ShopOrdersStatus.loaded) {
      return state.orders.firstWhere(
        (o) => o.id == fallbackOrder.id,
        orElse: () => fallbackOrder,
      );
    }
    return fallbackOrder;
  }

  // Calculate refund amount
  static double calculateRefundAmount(List<OrderItemModel> returnedItems) {
    return returnedItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }
}
