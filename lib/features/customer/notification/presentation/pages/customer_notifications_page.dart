import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/theme/customer/customer_text_styles.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_bloc.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_event.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_state.dart';
import 'package:street_cart/features/customer/orders/presentation/pages/order_details_page.dart';
import 'package:street_cart/features/customer/products/presentation/pages/customer_product_detail_page.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_event.dart';
import 'package:street_cart/features/customer/notification/presentation/widgets/customer_notification_list.dart';

// Customer Notifications Page
class CustomerNotificationsPage extends StatelessWidget {
  const CustomerNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark
        ? CustomerAppColors.darkTextPrimary
        : CustomerAppColors.textPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark
            ? CustomerAppColors.darkBackground
            : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: titleColor),
          onPressed: () => Navigator.pop(context),
        ),
        // Page Header
        title: Text(
          'Notifications',
          style: CustomerAppTextStyles.heading2.copyWith(color: titleColor),
        ),
        // Mark read all notifications
        actions: [
          BlocBuilder<CustomerNotificationsBloc, CustomerNotificationsState>(
            builder: (context, state) {
              if (state.unreadCount > 0) {
                return TextButton.icon(
                  onPressed: () {
                    context.read<CustomerNotificationsBloc>().add(
                      MarkAllAsReadEvent(state.userId),
                    );
                  },
                  icon: Icon(
                    Icons.done_all,
                    size: 16.sp,
                    color: CustomerAppColors.primary,
                  ),
                  label: Text(
                    'Mark all read',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: CustomerAppColors.primary,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocListener<CustomerNotificationsBloc, CustomerNotificationsState>(
        listenWhen: (previous, current) =>
            previous.selectedOrder != current.selectedOrder ||
            previous.selectedProduct != current.selectedProduct ||
            previous.status != current.status,
        listener: (context, state) {
          if (state.status == CustomerNotificationsStatus.orderLoaded &&
              state.selectedOrder != null) {
            final order = state.selectedOrder!;
            final notifId = state.selectedNotificationId;
            if (notifId != null) {
              context.read<CustomerNotificationsBloc>().add(
                MarkAsReadEvent(userId: state.userId, notificationId: notifId),
              );
            }
            context.read<CustomerNotificationsBloc>().add(
              const ClearSelectedOrderEvent(),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => sl<OrdersBloc>()..add(FetchOrders()),
                  // Navigate to Order Details Page
                  child: OrderDetailsPage(order: order),
                ),
              ),
              (route) => route.isFirst,
            );
          } else if (state.status ==
                  CustomerNotificationsStatus.productLoaded &&
              state.selectedProduct != null &&
              state.selectedShop != null) {
            final product = state.selectedProduct!;
            final shop = state.selectedShop!;
            final notifId = state.selectedNotificationId;
            if (notifId != null) {
              context.read<CustomerNotificationsBloc>().add(
                MarkAsReadEvent(userId: state.userId, notificationId: notifId),
              );
            }
            context.read<CustomerNotificationsBloc>().add(
              const ClearSelectedProductEvent(),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    // Navigate to Customer Product Detail Page
                    CustomerProductDetailPage(product: product, shop: shop),
              ),
            );
          } else if ((state.status == CustomerNotificationsStatus.orderError ||
                  state.status == CustomerNotificationsStatus.productError) &&
              state.errorMessage != null) {
            CustomSnackBar.show(
              context,
              message: state.errorMessage!,
              isError: true,
            );
          }
        },
        // Customer Notification List
        child: const CustomerNotificationList(),
      ),
    );
  }
}
