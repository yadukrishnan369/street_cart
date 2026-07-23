import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/customers/data/models/customer_model.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customer_detail_bloc.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customer_detail_event.dart';

class AdminCustomersHelper {
  // customer display initials
  static String getCustomerInitials(
    String name, {
    String defaultInitials = 'JD',
  }) {
    if (name.isEmpty) return defaultInitials;
    return name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase();
  }

  // get status Bg color
  static Color getStatusBgColor(bool isBlocked) {
    return isBlocked ? const Color(0xFFFDE8E8) : const Color(0xFFDEF7EC);
  }

  // get status text color
  static Color getStatusTextColor(bool isBlocked) {
    return isBlocked ? const Color(0xFF9B1C1C) : const Color(0xFF03543F);
  }

  // get status label
  static String getStatusLabel(bool isBlocked) {
    return isBlocked ? 'Blocked' : 'Active';
  }

  // get returns count
  static int getReturnsCount(List<OrderModel> orders) {
    return orders
        .where((o) => o.returnStatus != null && o.returnStatus!.isNotEmpty)
        .length;
  }

  // get cancelled count
  static int getCancelledCount(List<OrderModel> orders) {
    return orders.where((o) => o.status.toLowerCase() == 'cancelled').length;
  }

  // get completed count
  static int getCompletedCount(List<OrderModel> orders) {
    return orders.where((o) {
      final status = o.status.toLowerCase();
      final isReturned = o.returnStatus != null && o.returnStatus!.isNotEmpty;
      return status == 'delivered' && !isReturned;
    }).length;
  }

  // Calculates total spent amount
  static double getTotalSpent(List<OrderModel> orders) {
    double totalSpent = 0.0;
    for (final order in orders) {
      final isCancelled = order.status.toLowerCase() == 'cancelled';
      final isReturned =
          order.returnStatus != null && order.returnStatus!.isNotEmpty;
      if (!isCancelled && !isReturned) {
        totalSpent += order.totalAmount;
      }
    }
    return totalSpent;
  }

  // total number of pages for pagination
  static int getTotalPages(int totalItems, int perPage) {
    return (totalItems / perPage).ceil().clamp(1, 999999);
  }

  //  get paginated list
  static List<T> getPaginatedList<T>(
    List<T> list,
    int currentPage,
    int perPage,
  ) {
    if (list.isEmpty) return [];
    return list.skip((currentPage - 1) * perPage).take(perPage).toList();
  }

  // formats the order items list
  static String formatOrderItems(List<OrderItemModel> items) {
    if (items.isEmpty) return '';
    final firstItemName = items.first.productName;
    if (items.length == 1) {
      return firstItemName;
    }
    final remainingCount = items.length - 1;
    return '$firstItemName + $remainingCount more';
  }

  // formats customer primary address
  static String getPrimaryAddressText(List<AddressModel> addresses) {
    if (addresses.isEmpty) {
      return 'No address registered yet.';
    }
    final defaultAddr = addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => addresses.first,
    );
    return '${defaultAddr.addressLine1}, ${defaultAddr.addressLine2}\n${defaultAddr.city} - ${defaultAddr.pincode}';
  }

  // confirmation dialog to block/unblock the customer
  static void confirmBlockToggle(BuildContext context, CustomerModel customer) {
    final isBlocked = customer.isBlocked;
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: isBlocked ? 'Unblock Customer' : 'Block Customer',
        content:
            'Are you sure you want to ${isBlocked ? "unblock" : "block"} "${customer.fullName}"?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: isBlocked ? 'Unblock' : 'Block',
        icon: isBlocked ? Icons.check_circle_outline : Icons.block_outlined,
        iconColor: isBlocked
            ? AdminAppColors.successColor
            : AdminAppColors.errorColor,
        primaryActionColor: isBlocked
            ? AdminAppColors.successColor
            : AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          context.read<AdminCustomerDetailBloc>().add(
            ToggleBlockStatusRequested(
              uid: customer.uid,
              isBlocked: !isBlocked,
            ),
          );
        },
      ),
    );
  }

  // confirmation dialog to delete the customer
  static void confirmDelete(BuildContext context, CustomerModel customer) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Delete Customer',
        content: 'Are you sure you want to delete "${customer.fullName}"?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Delete',
        icon: Icons.delete_outline,
        iconColor: AdminAppColors.errorColor,
        primaryActionColor: AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          confirmDeleteSecondStep(context, customer);
        },
      ),
    );
  }

  // confirmation for permanent customer deletion
  static void confirmDeleteSecondStep(
    BuildContext context,
    CustomerModel customer,
  ) {
    showDialog(
      context: context,
      builder: (dialogCtx) => CustomAlertDialog(
        title: 'Permanently Delete Customer',
        content:
            'This action is irreversible. All profile data for "${customer.fullName}" will be permanently deleted. Do you want to proceed?',
        secondaryActionLabel: 'Cancel',
        primaryActionLabel: 'Permanently Delete',
        icon: Icons.warning_amber_outlined,
        iconColor: AdminAppColors.errorColor,
        primaryActionColor: AdminAppColors.errorColor,
        onPrimaryAction: () {
          Navigator.pop(dialogCtx);
          context.read<AdminCustomerDetailBloc>().add(
            DeleteCustomerRequested(customer.uid),
          );
        },
      ),
    );
  }
}
