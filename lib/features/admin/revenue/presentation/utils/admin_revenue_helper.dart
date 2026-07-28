import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/auth/data/models/shop_profile_model.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';

class AdminRevenueHelper {
  // List of Time Frames
  static const List<String> timeframes = [
    'All Time',
    'Today',
    'Last 7 Days',
    'Last Month',
    'Last 6 Months',
    'Last 1 Year',
    'Custom',
  ];
  // Get Business Categories
  static List<String> getBusinessCategories(List<ShopProfileModel> shops) {
    final cats =
        shops.map((s) => s.category).where((c) => c.isNotEmpty).toSet().toList()
          ..sort();
    return ['All', ...cats];
  }

  // Get Product Categories
  static List<String> getProductCategories(List<ProductModel> products) {
    final cats =
        products
            .map((p) => p.category)
            .where((c) => c.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return ['All', ...cats];
  }

  // Filter Completed Orders Only
  static List<OrderModel> filterCompletedOrdersOnly(List<OrderModel> orders) {
    return orders.where((o) {
      final status = o.status.toLowerCase();
      final hasReturn = o.returnStatus != null && o.returnStatus!.isNotEmpty;
      return status == 'delivered' && !hasReturn;
    }).toList();
  }

  // Apply Filters
  static List<OrderModel> applyFilters({
    required List<OrderModel> orders,
    required List<ShopProfileModel> shops,
    required List<ProductModel> products,
    required List<CustomerModel> customers,
    required String businessCategory,
    required String productCategory,
    required String timeframe,
    DateTime? customStart,
    DateTime? customEnd,
    required String searchQuery,
  }) {
    final shopMap = {for (final s in shops) s.uid: s};
    final productMap = {for (final p in products) p.id: p};
    final customerMap = {for (final c in customers) c.uid: c};

    final dateRange = _getDateRange(timeframe, customStart, customEnd);
    final q = searchQuery.toLowerCase();

    return orders.where((order) {
      final status = order.status.toLowerCase();
      final hasReturn =
          order.returnStatus != null && order.returnStatus!.isNotEmpty;
      if (status != 'delivered' || hasReturn) return false;

      if (dateRange != null) {
        if (order.createdAt.isBefore(dateRange.$1) ||
            order.createdAt.isAfter(dateRange.$2)) {
          return false;
        }
      }

      if (businessCategory != 'All') {
        final shopIds = order.items.map((i) => i.shopId).toSet();
        final matchShop = shopIds.any(
          (id) => shopMap[id]?.category == businessCategory,
        );
        if (!matchShop) return false;
      }

      if (productCategory != 'All') {
        final productIds = order.items.map((i) => i.productId).toSet();
        final matchProd = productIds.any(
          (id) => productMap[id]?.category == productCategory,
        );
        if (!matchProd) return false;
      }

      if (q.isNotEmpty) {
        final matchId = order.id.toLowerCase().contains(q);
        final custName = customerMap[order.customerId]?.fullName ?? '';
        final matchCustomer = custName.toLowerCase().contains(q);
        final matchShopName = order.items.any(
          (i) => (shopMap[i.shopId]?.shopName ?? '').toLowerCase().contains(q),
        );
        if (!matchId && !matchCustomer && !matchShopName) return false;
      }

      return true;
    }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Get Date Range
  static (DateTime, DateTime)? _getDateRange(
    String timeframe,
    DateTime? customStart,
    DateTime? customEnd,
  ) {
    final now = DateTime.now();
    switch (timeframe) {
      case 'Today':
        return (
          DateTime(now.year, now.month, now.day),
          DateTime(now.year, now.month, now.day, 23, 59, 59),
        );
      case 'Last 7 Days':
        return (now.subtract(const Duration(days: 7)), now);
      case 'Last Month':
        return (DateTime(now.year, now.month - 1, now.day), now);
      case 'Last 6 Months':
        return (DateTime(now.year, now.month - 6, now.day), now);
      case 'Last 1 Year':
        return (DateTime(now.year - 1, now.month, now.day), now);
      case 'Custom':
        if (customStart != null && customEnd != null) {
          return (customStart, customEnd);
        }
        return null;
      default:
        return null;
    }
  }

  // Get Total Revenue
  static double computeTotalRevenue(List<OrderModel> orders) {
    double total = 0.0;
    for (final order in orders) {
      total += computeOrderCommission(order);
    }
    return total;
  }

  // Get Today Revenue
  static double computeTodayRevenue(List<OrderModel> orders) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    double total = 0.0;
    for (final order in orders) {
      if (order.createdAt.isAfter(start) && order.createdAt.isBefore(end)) {
        total += computeOrderCommission(order);
      }
    }
    return total;
  }

  // Get Last Month Revenue
  static double computeLastMonthRevenue(List<OrderModel> orders) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - 1, now.day);
    double total = 0.0;
    for (final order in orders) {
      if (order.createdAt.isAfter(start) && order.createdAt.isBefore(now)) {
        total += computeOrderCommission(order);
      }
    }
    return total;
  }

  // Get Order Commission Amount
  static double computeOrderCommission(OrderModel order) {
    return order.items.fold(0.0, (sum, item) => sum + item.adminCommission);
  }

  // Get Order ID
  static String formatOrderId(String id) {
    return id.length > 8 ? '#${id.substring(0, 6).toUpperCase()}' : '#$id';
  }

  // Format Dates
  static String formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // Get Shop Name
  static String getShopName(OrderModel order, List<ShopProfileModel> shops) {
    if (order.items.isEmpty) return '—';
    final shopId = order.items.first.shopId;
    try {
      return shops.firstWhere((s) => s.uid == shopId).shopName;
    } catch (_) {
      return 'Unknown Shop';
    }
  }

  // Get Customer Name
  static String getCustomerName(
    OrderModel order,
    List<CustomerModel> customers,
  ) {
    try {
      final cust = customers.firstWhere((c) => c.uid == order.customerId);
      if (cust.fullName.isNotEmpty) return cust.fullName;
    } catch (_) {}
    return '—';
  }
}
