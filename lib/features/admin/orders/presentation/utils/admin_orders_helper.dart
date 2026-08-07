import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';

class AdminOrdersHelper {
  // get Display Order ID
  static String getDisplayOrderId(String id) {
    if (id.length <= 4) return '#ORD-$id'.toUpperCase();
    return '#ORD-${id.substring(id.length - 4)}'.toUpperCase();
  }

  // Get Shop Name
  static String getShopName(OrderModel order, Map<String, String> shopNames) {
    if (order.items.isEmpty) return 'No Shop';
    final shopId = order.items.first.shopId;
    return shopNames[shopId] ?? 'Unknown Shop';
  }

  // Get Total Pages
  static int getTotalPages(int totalItems, int perPage) {
    return (totalItems / perPage).ceil().clamp(1, double.infinity).toInt();
  }

  // Get Paginated Orders
  static List<OrderModel> getPaginatedOrders({
    required List<OrderModel> orders,
    required int currentPage,
    required int perPage,
  }) {
    return orders.skip((currentPage - 1) * perPage).take(perPage).toList();
  }

  // Get Payment Status
  static String getPaymentStatus(OrderModel order) {
    final method = order.paymentMethod.toLowerCase();
    if (method == 'cod' || method == 'cash on delivery') {
      return order.status.toLowerCase() == 'delivered' ? 'PAID' : 'PENDING';
    }
    return 'PAID';
  }

  // Calculate Subtotal
  static double calculateSubtotal(OrderModel order) {
    final allItemsCancelled =
        order.items.isNotEmpty &&
        order.items.every((i) => i.status == 'cancelled');
    if (order.status.toLowerCase() == 'cancelled' || allItemsCancelled)
      return 0.0;
    double subtotal = 0.0;
    for (final item in order.items) {
      final isItemReturned =
          item.returnStatus != null && item.returnStatus!.isNotEmpty;
      final isItemCancelled = item.status == 'cancelled';
      if (!isItemReturned && !isItemCancelled) {
        subtotal += item.price * item.quantity;
      }
    }
    return subtotal;
  }

  // Calculate Commission
  static double calculateCommission(OrderModel order) {
    final allItemsCancelled =
        order.items.isNotEmpty &&
        order.items.every((i) => i.status == 'cancelled');
    if (order.status.toLowerCase() == 'cancelled' || allItemsCancelled)
      return 0.0;
    // commission stored per item - set when order was placed
    double commission = 0.0;
    for (final item in order.items) {
      final isItemReturned =
          item.returnStatus != null && item.returnStatus!.isNotEmpty;
      final isItemCancelled = item.status == 'cancelled';
      if (!isItemReturned && !isItemCancelled) {
        commission += item.adminCommission;
      }
    }
    return commission;
  }

  // Calculate Commission Percentage
  static double calculateCommissionPercentage(OrderModel order) {
    final allItemsCancelled =
        order.items.isNotEmpty &&
        order.items.every((i) => i.status == 'cancelled');
    if (order.status.toLowerCase() == 'cancelled' || allItemsCancelled)
      return 0.0;
    double totalProductPriceAmount = 0.0;
    double totalCommissionAmount = 0.0;
    for (final item in order.items) {
      final isItemReturned =
          item.returnStatus != null && item.returnStatus!.isNotEmpty;
      final isItemCancelled = item.status == 'cancelled';
      if (!isItemReturned && !isItemCancelled) {
        totalProductPriceAmount += item.price * item.quantity;
        totalCommissionAmount += item.adminCommission;
      }
    }
    if (totalProductPriceAmount > 0) {
      return (totalCommissionAmount / totalProductPriceAmount) * 100;
    }
    return 0.0;
  }

  // Calculate Vendor Earnings
  static double calculateVendorEarnings(OrderModel order) {
    final allItemsCancelled =
        order.items.isNotEmpty &&
        order.items.every((i) => i.status == 'cancelled');
    if (order.status.toLowerCase() == 'cancelled' || allItemsCancelled)
      return 0.0;
    double earnings = 0.0;
    for (final item in order.items) {
      final isItemReturned =
          item.returnStatus != null && item.returnStatus!.isNotEmpty;
      final isItemCancelled = item.status == 'cancelled';
      if (!isItemReturned && !isItemCancelled) {
        earnings += item.vendorEarnings;
      }
    }
    return earnings;
  }

  // Calculate After Deduction
  static double calculateAfterDeduction(double subtotal, double commission) {
    return subtotal - commission;
  }

  // Calculate Amount After Comm
  static double calculateAmountAfterComm(double total, double commission) {
    return total - commission;
  }

  // Get Tracking Step Index
  static int getTrackingStepIndex(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return 1;
      case 'packed':
      case 'shipped':
        return 2;
      case 'delivered':
        return 3;
      case 'cancelled':
        return -1;
      default:
        return 0;
    }
  }

  // Get Filtered Orders
  static List<OrderModel> getFilteredOrders({
    required List<OrderModel> orders,
    required Map<String, String> shopNames,
    required int activeTab,
    required String query,
  }) {
    // Tab Status Filter
    List<OrderModel> filtered = orders;
    if (activeTab > 0) {
      filtered = orders.where((order) {
        final status = order.status.toLowerCase();
        switch (activeTab) {
          case 1: // Processing
            return status == 'processing';
          case 2: // Packed/Shipped
            return status == 'packed' || status == 'shipped';
          case 3: // Completed - Delivered and has at least one completed item
            final hasCompletedItem = order.items.any(
              (item) =>
                  item.status != 'cancelled' &&
                  (item.returnStatus == null || item.returnStatus!.isEmpty),
            );
            return status == 'delivered' && hasCompletedItem;
          case 4: // Cancelled/Returned - Cancelled order or has any cancelled/returned item
            final hasCancelledOrReturnedItem = order.items.any(
              (item) =>
                  item.status == 'cancelled' ||
                  (item.returnStatus != null && item.returnStatus!.isNotEmpty),
            );
            return status == 'cancelled' || hasCancelledOrReturnedItem;
          default:
            return true;
        }
      }).toList();
    }

    // Search Query Filter
    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      filtered = filtered.where((order) {
        final fullOrderId = order.id.toLowerCase();
        final displayOrderId = getDisplayOrderId(order.id).toLowerCase();
        final customerName = order.deliveryAddress.fullName.toLowerCase();
        final shopName = getShopName(order, shopNames).toLowerCase();
        final orderDate = DateFormatter.formatToReadableDate(
          order.createdAt,
        ).toLowerCase();
        final orderTime = DateFormatter.formatToTime(
          order.createdAt,
        ).toLowerCase();
        final matchesProduct = order.items.any(
          (item) => item.productName.toLowerCase().contains(q),
        );

        return fullOrderId.contains(q) ||
            displayOrderId.contains(q) ||
            customerName.contains(q) ||
            shopName.contains(q) ||
            orderDate.contains(q) ||
            orderTime.contains(q) ||
            matchesProduct;
      }).toList();
    }

    return filtered;
  }

  // Get Status Bg Color
  static Color getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return const Color(0xFFE8F0FE);
      case 'packed':
      case 'shipped':
        return const Color(0xFFF4EBFF);
      case 'delivered':
        return const Color(0xFFE6F4EA);
      case 'cancelled':
        return const Color(0xFFFCE8E6);
      case 'returned':
      case 'return_picked':
        return const Color(0xFFFFF3E0);
      case 'return_requested':
        return const Color(0xFFFFF9DB);
      case 'return_confirmed':
        return const Color(0xFFE3FAF2);
      default:
        return const Color(0xFFF1F3F4);
    }
  }

  // Get Status Text Color
  static Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return const Color(0xFF1A73E8);
      case 'packed':
      case 'shipped':
        return const Color(0xFF7B2CBF);
      case 'delivered':
        return AdminAppColors.successColor;
      case 'cancelled':
        return AdminAppColors.errorColor;
      case 'returned':
      case 'return_picked':
        return AdminAppColors.warningColor;
      case 'return_requested':
        return const Color(0xFFF59F00);
      case 'return_confirmed':
        return const Color(0xFF0CA678);
      default:
        return const Color(0xFF5F6368);
    }
  }

  // Get Status Label
  static String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return 'Processing';
      case 'packed':
      case 'shipped':
        return 'Packed/Shipped';
      case 'delivered':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'returned':
      case 'return_picked':
        return 'Returned';
      case 'return_requested':
        return 'Return Requested';
      case 'return_confirmed':
        return 'Return Confirmed';
      default:
        return status.toUpperCase();
    }
  }

  // Get Shop Initials
  static String getShopInitials(String shopName) {
    return shopName.length >= 2 ? shopName.substring(0, 2).toUpperCase() : 'SH';
  }

  // Get Shop Address
  static String getShopAddress(ShopProfileModel? shop) {
    return shop != null
        ? '${shop.fullAddress}, ${shop.city}'
        : 'Address unavailable';
  }

  // Get Shop Phone
  static String getShopPhone(ShopProfileModel? shop) {
    return shop?.phone ?? 'N/A';
  }

  // Get returned items
  static List<OrderItemModel> getReturnedItems(OrderModel order) {
    return order.items
        .where((i) => i.returnStatus != null && i.returnStatus!.isNotEmpty)
        .toList();
  }

  // Get cancelled items
  static List<OrderItemModel> getCancelledItems(OrderModel order) {
    return order.items.where((i) => i.status == 'cancelled').toList();
  }

  // Check if all items cancelled
  static bool isAllItemsCancelled(OrderModel order) {
    return order.items.isNotEmpty &&
        order.items.every((i) => i.status == 'cancelled');
  }

  // Check if all items returned
  static bool isAllItemsReturned(OrderModel order) {
    return order.items.isNotEmpty &&
        order.items.every(
          (i) => i.returnStatus != null && i.returnStatus!.isNotEmpty,
        );
  }

  // Check if all items cancelled or returned
  static bool isAllItemsCancelledOrReturned(OrderModel order) {
    return order.items.isNotEmpty &&
        order.items.every(
          (i) =>
              i.status == 'cancelled' ||
              (i.returnStatus != null && i.returnStatus!.isNotEmpty),
        );
  }
}
