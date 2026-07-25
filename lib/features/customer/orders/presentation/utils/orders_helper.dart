import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/customer_order_status.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_state.dart';
import 'package:street_cart/shared/widgets/custom_confirmation_modal.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_event.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/get_product_by_id.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/get_shop_by_id.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_product_detail_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class OrdersHelper {
  // Sort orders by creation time
  static List<OrderModel> getOrdersSortedByTime(List<OrderModel> orders) {
    return List<OrderModel>.from(orders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Extract current Order
  static OrderModel getCurrentOrder(OrdersState state, OrderModel order) {
    if (state is OrdersLoaded) {
      return state.orders.firstWhere(
        (o) => o.id == order.id,
        orElse: () => order,
      );
    }
    return order;
  }

  // Get Order ID
  static String getOrderIdSuffix(String id) {
    if (id.length <= 4) return 'SC-$id'.toUpperCase();
    return 'ORD-${id.substring(id.length - 4)}'.toUpperCase();
  }

  // Date Formatter
  static String formatDateShort(DateTime dateTime) {
    return DateFormat('MMM dd').format(dateTime);
  }

  // Check If order Able To Cancel
  static bool isCancellable(CustomerOrderStatus status) {
    return status == CustomerOrderStatus.placed;
  }

  // calculates total item counts inside an order
  static int getOrderTotalItems(OrderModel order) {
    return order.items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  // Check If Order Delivered or Not
  static bool isDelivered(CustomerOrderStatus status) {
    return status == CustomerOrderStatus.delivered;
  }

  // Check If Order Cancell or Not
  static bool isCancelled(CustomerOrderStatus status) {
    return status == CustomerOrderStatus.cancelled;
  }

  // formats products display label for order cards
  static String getOrderDisplayName(OrderModel order) {
    if (order.items.isEmpty) return '';
    final firstItem = order.items.first;
    return order.items.length > 1
        ? '${firstItem.productName} and ${order.items.length - 1} more'
        : firstItem.productName;
  }

  // Returns only if the order is delivered with return option
  static bool isReturnEligible(OrderModel order) {
    final status = CustomerOrderStatus.fromString(order.status);
    if (status != CustomerOrderStatus.delivered) return false;
    final deliveredAt = order.deliveredAt;
    if (deliveredAt == null) return false;
    final returnDeadline = deliveredAt.add(const Duration(days: 4));
    return DateTime.now().isBefore(returnDeadline);
  }

  // Get Order Tracking Status Color
  static Color getStatusColor(CustomerOrderStatus status) {
    switch (status) {
      case CustomerOrderStatus.placed:
        return Colors.orange;
      case CustomerOrderStatus.processing:
        return Colors.blue;
      case CustomerOrderStatus.shipped:
        return Colors.indigo;
      case CustomerOrderStatus.delivered:
        return Colors.green;
      case CustomerOrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get Order Tracking Status
  static String getDisplayStatus(CustomerOrderStatus status) {
    switch (status) {
      case CustomerOrderStatus.placed:
        return 'PLACED';
      case CustomerOrderStatus.processing:
        return 'ORDER CONFIRMED';
      case CustomerOrderStatus.shipped:
        return 'PACKED & SHIPPED';
      case CustomerOrderStatus.delivered:
        return 'DELIVERED';
      case CustomerOrderStatus.cancelled:
        return 'CANCELLED';
      default:
        return status.value.toUpperCase();
    }
  }

  // Get Delivery Progress Index
  static int getProgressIndex(CustomerOrderStatus status) {
    switch (status) {
      case CustomerOrderStatus.placed:
        return 0;
      case CustomerOrderStatus.processing:
        return 1;
      case CustomerOrderStatus.shipped:
        return 2;
      case CustomerOrderStatus.delivered:
        return 3;
      default:
        return 0;
    }
  }

  // Get Delivery Progress Steps
  static List<Map<String, dynamic>> getProgressSteps(OrderModel order) {
    final status = CustomerOrderStatus.fromString(order.status);

    final placedTime = DateFormatter.formatToOrderDateTime(order.createdAt);
    final confirmedTime = order.confirmedAt != null
        ? DateFormatter.formatToOrderDateTime(order.confirmedAt!)
        : '';
    final shippedTime = order.shippedAt != null
        ? DateFormatter.formatToOrderDateTime(order.shippedAt!)
        : '';
    final deliveredTime = order.deliveredAt != null
        ? DateFormatter.formatToOrderDateTime(order.deliveredAt!)
        : '';

    return [
      {'title': 'Order Placed', 'time': placedTime, 'completed': true},
      {
        'title': 'Order Confirmed',
        'time': confirmedTime.isNotEmpty
            ? confirmedTime
            : (status == CustomerOrderStatus.placed)
            ? 'Waiting for confirmation'
            : 'Pending',
        'completed': order.confirmedAt != null,
      },
      {
        'title': 'Packed & Shipped',
        'time': shippedTime.isNotEmpty
            ? shippedTime
            : (status == CustomerOrderStatus.processing)
            ? 'Preparing/Shipped'
            : 'Pending',
        'completed': order.shippedAt != null,
      },
      {
        'title': 'Delivered',
        'time': deliveredTime.isNotEmpty
            ? deliveredTime
            : (status == CustomerOrderStatus.shipped)
            ? 'Out for delivery'
            : 'Pending',
        'completed': order.deliveredAt != null,
      },
    ];
  }

  // Convert To Cart Items
  static List<CartItem> convertToCartItems(List<OrderItemModel> items) {
    return items.map((item) {
      return CartItem(
        id: item.id,
        productId: item.productId,
        productName: item.productName,
        productImage: item.productImage,
        selectedSize: item.selectedSize,
        selectedColor: item.selectedColor,
        price: item.price,
        quantity: item.quantity,
        shopId: item.shopId,
        addedAt: DateTime.now(),
      );
    }).toList();
  }

  // Confirmation Modal For Change Delivery Address
  static void showChangeAddressConfirmation({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationModal(
        title: 'Change Delivery Address?',
        content:
            'Are you sure you want to change the delivery address for this order?',
        confirmText: 'Yes, Change',
        cancelText: 'Cancel',
        confirmColor: CustomerAppColors.primary,
        onConfirm: () {
          Navigator.pop(ctx);
          onConfirm();
        },
        onCancel: () => Navigator.pop(ctx),
      ),
    );
  }

  // Modal For Cancel Entire Order
  static void showCancelOrderDialog({
    required BuildContext context,
    required String orderId,
    required OrdersBloc ordersBloc,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Cancel Order',
        content: 'Are you sure you want to cancel this order?',
        secondaryActionLabel: 'No, Keep it',
        onSecondaryAction: () => Navigator.pop(dialogCtx),
        primaryActionLabel: 'Yes, Cancel',
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          ordersBloc.add(CancelOrderEvent(orderId));
        },
        icon: Icons.cancel_outlined,
        iconColor: CustomerAppColors.error,
        primaryActionColor: CustomerAppColors.error,
      ),
    );
  }

  // Modal For Cancel Product Item
  static void showCancelOrderItemDialog({
    required BuildContext context,
    required String orderId,
    required String orderItemId,
    required OrdersBloc ordersBloc,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Cancel Item',
        content: 'Are you sure you want to cancel this item?',
        secondaryActionLabel: 'No, Keep it',
        onSecondaryAction: () => Navigator.pop(dialogCtx),
        primaryActionLabel: 'Yes, Cancel',
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          ordersBloc.add(CancelOrderItemEvent(orderId, orderItemId));
        },
        icon: Icons.cancel_outlined,
        iconColor: CustomerAppColors.error,
        primaryActionColor: CustomerAppColors.error,
      ),
    );
  }

  // Show Modal for Delivery Not Available
  static void showOutOfRadiusDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => PopScope(
        canPop: false,
        child: CustomAlertDialog(
          title: 'Delivery Not Available',
          content:
              'This shop does not deliver to the selected address. Please choose another delivery address within the delivery area.',
          primaryActionLabel: 'OK',
          primaryActionColor: CustomerAppColors.primary,
          icon: Icons.error_outline,
          iconColor: CustomerAppColors.error,
          onPrimaryAction: () => Navigator.pop(dialogCtx),
        ),
      ),
    );
  }

  // Confirmation for Submit Return Request
  static void showConfirmSubmitReturnDialog({
    required BuildContext context,
    required String orderId,
    required String itemId,
    required String reason,
    required String details,
    required OrdersBloc ordersBloc,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Confirm Return Request',
        content:
            'Are you sure you want to submit a return request for this item?',
        secondaryActionLabel: 'Cancel',
        onSecondaryAction: () => Navigator.pop(dialogCtx),
        primaryActionLabel: 'Yes, Submit',
        primaryActionColor: CustomerAppColors.primary,
        icon: Icons.assignment_return_rounded,
        iconColor: CustomerAppColors.primary,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          ordersBloc.add(
            SubmitReturnRequestEvent(
              orderId: orderId,
              itemId: itemId,
              reason: reason,
              details: details,
            ),
          );
        },
      ),
    );
  }

  // Navigate to Customer Product Detail Page
  static Future<void> navigateToProductDetails({
    required BuildContext context,
    required String productId,
    required String shopId,
    String? selectedColor,
    String? selectedSize,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final product = await sl<GetProductById>().call(productId);
      final shop = await sl<GetShopById>().call(shopId);

      if (context.mounted) {
        Navigator.pop(context); // Dismiss loading dialog
      }

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerProductDetailPage(
              product: product,
              shop: shop,
              initialColor: selectedColor,
              initialSize: selectedSize,
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
}
