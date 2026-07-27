import 'package:flutter/material.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:intl/intl.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';

class SalesAnalyticsHelper {
  // Calculate earnings for a shop
  static double calculateTotalEarnings(
    List<OrderModel> orders,
    String shopId,
    Map<String, String> productCategories,
    String selectedCategory,
  ) {
    double total = 0.0;
    for (final order in orders) {
      final status = order.status.toLowerCase();
      final isDelivered = status == 'delivered';
      final isReturned =
          order.returnStatus != null && order.returnStatus!.isNotEmpty;
      final isCancelled = status == 'cancelled';

      if (isDelivered && !isReturned && !isCancelled) {
        for (final item in order.items) {
          if (item.shopId == shopId) {
            final category = productCategories[item.productId] ?? 'Other';
            if (selectedCategory == 'All' || category == selectedCategory) {
              total += item.price * item.quantity;
            }
          }
        }
      }
    }
    return total;
  }

  // Calculate earnings for a specific timeframe
  static double calculateTimeframeEarnings({
    required List<OrderModel> orders,
    required String shopId,
    required Map<String, String> productCategories,
    required String selectedCategory,
    required DateTime start,
    required DateTime end,
  }) {
    final filtered = filterOrdersByDateRange(orders, start, end);
    return calculateTotalEarnings(
      filtered,
      shopId,
      productCategories,
      selectedCategory,
    );
  }

  // Filter orders by date range
  static List<OrderModel> filterOrdersByDateRange(
    List<OrderModel> orders,
    DateTime start,
    DateTime end,
  ) {
    final startTime = DateTime(start.year, start.month, start.day);
    final endTime = DateTime(end.year, end.month, end.day, 23, 59, 59);

    return orders.where((order) {
      return order.createdAt.isAfter(startTime) &&
          order.createdAt.isBefore(endTime);
    }).toList();
  }

  // Filter orders by category
  static List<OrderModel> filterOrdersByCategory(
    List<OrderModel> orders,
    String shopId,
    Map<String, String> productCategories,
    String selectedCategory,
  ) {
    if (selectedCategory == 'All') return orders;
    return orders.where((order) {
      return order.items.any((item) {
        if (item.shopId != shopId) return false;
        final category = productCategories[item.productId] ?? 'Other';
        return category == selectedCategory;
      });
    }).toList();
  }

  // Filter orders by predefined timeframe selection
  static List<OrderModel> filterOrdersByTimeframe(
    List<OrderModel> orders,
    String timeframe,
  ) {
    final now = DateTime.now();
    switch (timeframe) {
      case 'Today':
        return filterOrdersByDateRange(orders, now, now);
      case 'Last 7 Days':
        return filterOrdersByDateRange(
          orders,
          now.subtract(const Duration(days: 7)),
          now,
        );
      case 'Last Month':
        return filterOrdersByDateRange(
          orders,
          now.subtract(const Duration(days: 30)),
          now,
        );
      case 'Last 6 Month':
        return filterOrdersByDateRange(
          orders,
          now.subtract(const Duration(days: 180)),
          now,
        );
      case 'Last 1 Year':
        return filterOrdersByDateRange(
          orders,
          now.subtract(const Duration(days: 365)),
          now,
        );
      default:
        return orders;
    }
  }

  // Calculate Order Summary Statistics
  static Map<String, int> calculateOrderSummary(List<OrderModel> orders) {
    int completed = 0;
    int pending = 0;
    int cancelled = 0;

    for (final order in orders) {
      final status = order.status.toLowerCase();
      final isReturned =
          order.returnStatus != null && order.returnStatus!.isNotEmpty;
      final isCancelled = status == 'cancelled';
      final isDelivered = status == 'delivered';

      if (isCancelled || isReturned) {
        cancelled++;
      } else if (isDelivered) {
        completed++;
      } else {
        pending++;
      }
    }

    return {
      'total': completed + pending + cancelled,
      'completed': completed,
      'pending': pending,
      'cancelled': cancelled,
    };
  }

  // Get Recent Transactions
  static List<AnalyticsTransactionItem> getRecentTransactions(
    List<OrderModel> orders,
    String shopId,
    Map<String, String> productCategories,
    String selectedCategory,
  ) {
    final List<AnalyticsTransactionItem> list = [];
    for (final order in orders) {
      final status = order.status.toLowerCase();
      final isReturned =
          order.returnStatus != null && order.returnStatus!.isNotEmpty;
      final isCancelled = status == 'cancelled';
      final isDelivered = status == 'delivered';

      // Only show completed, returned, and cancelled orders
      if (isDelivered || isReturned || isCancelled) {
        for (final item in order.items) {
          if (item.shopId == shopId) {
            final category = productCategories[item.productId] ?? 'Other';
            if (selectedCategory == 'All' || category == selectedCategory) {
              String displayStatus = 'Paid';
              if (isCancelled) {
                displayStatus = 'Cancelled';
              } else if (isReturned) {
                displayStatus = 'Returned';
              }

              list.add(
                AnalyticsTransactionItem(
                  productName: item.productName,
                  productImage: item.productImage,
                  orderId: order.id,
                  date: order.createdAt,
                  amount: item.price * item.quantity,
                  status: displayStatus,
                  order: order,
                ),
              );
            }
          }
        }
      }
    }
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  // Get status background color
  static Color getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'cancelled':
        return const Color(0xFFFEF2F2);
      case 'returned':
        return const Color(0xFFFFF7ED);
      default:
        return const Color(0xFFE6F4EA);
    }
  }

  // Get status text color
  static Color getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'cancelled':
        return ShopAppColors.error;
      case 'returned':
        return ShopAppColors.warning;
      default:
        return ShopAppColors.success;
    }
  }

  // Format transaction header order ID + date
  static String formatTransactionHeader(String orderId, DateTime date) {
    final displayId = orderId.length > 8
        ? orderId.substring(0, 6).toUpperCase()
        : orderId.toUpperCase();
    return '#$displayId • ${DateFormatter.formatToReadableDate(date)}';
  }

  // Format Transaction ID
  static String formatTransID(String orderId) {
    final transId = orderId.length > 8
        ? orderId.substring(0, 6).toUpperCase()
        : orderId.toUpperCase();
    return transId;
  }

  // Get display for timeframe dropdown
  static String getDisplayTimeframe(
    String timeframe,
    DateTime? customStartDate,
    DateTime? customEndDate,
  ) {
    if (timeframe == 'Custom' &&
        customStartDate != null &&
        customEndDate != null) {
      final df = DateFormat('dd MMM');
      return '${df.format(customStartDate)} - ${df.format(customEndDate)}';
    }
    return timeframe;
  }

  // Confirmation for Call Customer and make Call
  static void callCustomer(
    BuildContext context,
    String fullName,
    String phone,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Call Customer',
        content: 'Do you want to make a call to $fullName?',
        primaryActionLabel: 'Call',
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          sl<CommunicationService>().makeCall(phone);
        },
        secondaryActionLabel: 'Cancel',
        onSecondaryAction: () => Navigator.pop(dialogCtx),
        icon: Icons.phone,
        iconColor: ShopAppColors.primary,
        primaryActionColor: ShopAppColors.primary,
      ),
    );
  }

  // Calculate completed sales count and total items sold count
  static Map<String, int> calculateSalesAndItemsCount({
    required List<OrderModel> orders,
    required String shopId,
    required Map<String, String> productCategories,
    required String selectedCategory,
  }) {
    int salesCount = 0;
    int itemsCount = 0;

    for (final order in orders) {
      final status = order.status.toLowerCase();
      final isDelivered = status == 'delivered';
      final isReturned =
          order.returnStatus != null && order.returnStatus!.isNotEmpty;
      final isCancelled = status == 'cancelled';

      if (isDelivered && !isReturned && !isCancelled) {
        bool hasShopItem = false;
        int orderItemsQuantity = 0;

        for (final item in order.items) {
          if (item.shopId == shopId) {
            final category = productCategories[item.productId] ?? 'Other';
            if (selectedCategory == 'All' || category == selectedCategory) {
              hasShopItem = true;
              orderItemsQuantity += item.quantity;
            }
          }
        }

        if (hasShopItem) {
          salesCount++;
          itemsCount += orderItemsQuantity;
        }
      }
    }

    return {'salesCount': salesCount, 'itemsCount': itemsCount};
  }
}

// Analytics Transaction Item Model
class AnalyticsTransactionItem {
  final String productName;
  final String productImage;
  final String orderId;
  final DateTime date;
  final double amount;
  final String status;
  final OrderModel order;

  AnalyticsTransactionItem({
    required this.productName,
    required this.productImage,
    required this.orderId,
    required this.date,
    required this.amount,
    required this.status,
    required this.order,
  });
}
