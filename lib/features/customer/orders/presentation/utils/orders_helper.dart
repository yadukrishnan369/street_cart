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

class OrdersHelper {
  static OrderModel getCurrentOrder(OrdersState state, OrderModel order) {
    if (state is OrdersLoaded) {
      return state.orders.firstWhere(
        (o) => o.id == order.id,
        orElse: () => order,
      );
    }
    return order;
  }

  static String getOrderIdSuffix(String id) {
    if (id.length <= 4) return 'SC-$id'.toUpperCase();
    return 'ORD-${id.substring(id.length - 4)}'.toUpperCase();
  }

  static String formatDateShort(DateTime dateTime) {
    return DateFormat('MMM dd').format(dateTime);
  }

  static bool isCancellable(CustomerOrderStatus status) {
    return status == CustomerOrderStatus.placed;
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

  static String getDisplayStatus(CustomerOrderStatus status) {
    switch (status) {
      case CustomerOrderStatus.placed:
        return 'ORDER PLACED';
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

  static bool isDelivered(CustomerOrderStatus status) {
    return status == CustomerOrderStatus.delivered;
  }

  static bool isCancelled(CustomerOrderStatus status) {
    return status == CustomerOrderStatus.cancelled;
  }

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
}
