import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_event.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_state.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/customer_order_status.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/delivery_progress_tracker.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/return_progress_tracker.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/order_details_status_banner.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/order_details_items_section.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/order_details_shipping_section.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/order_details_payment_section.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/order_details_reorder_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Orders Details Page
class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderIdText = OrdersHelper.getOrderIdSuffix(order.id);
    final activeColor = CustomerAppColors.primary;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        final currentOrder = OrdersHelper.getCurrentOrder(state, order);

        final status = CustomerOrderStatus.fromString(currentOrder.status);
        final isDelivered = OrdersHelper.isDelivered(status);
        final isCancelled = OrdersHelper.isCancelled(status);
        final returnStatus = (currentOrder.returnStatus ?? '').toLowerCase();
        final hasReturnRequest = returnStatus.isNotEmpty;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.cardColor,
            elevation: 0.5,
            centerTitle: true,
            title: Column(
              children: [
                // Page Header
                Text(
                  'Order Details',
                  style: TextStyle(
                    color: isDark
                        ? CustomerAppColors.darkTextPrimary
                        : CustomerAppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Order ID
                Text(
                  orderIdText,
                  style: TextStyle(
                    color: activeColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark
                    ? CustomerAppColors.darkTextPrimary
                    : CustomerAppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: BlocConsumer<OrdersBloc, OrdersState>(
            listener: (context, state) {
              if (state is OrderCancelledSuccess) {
                CustomSnackBar.show(
                  context,
                  message: 'Order cancelled successfully.',
                );
                Navigator.pop(context); // Go back after cancellation
              } else if (state is OrderItemCancelledSuccess) {
                CustomSnackBar.show(
                  context,
                  message: 'Item cancelled successfully.',
                );
              } else if (state is OrderAddressUpdateSuccess) {
                CustomSnackBar.show(
                  context,
                  message: 'Delivery address updated successfully.',
                );
                context.read<OrdersBloc>().add(FetchOrders());
              } else if (state is ReturnRequestSubmittedSuccess) {
                CustomSnackBar.show(
                  context,
                  message: 'Return request submitted successfully!',
                );
                context.read<OrdersBloc>().add(FetchOrders());
              } else if (state is OrdersFailure) {
                if (state.message.contains(
                  "does not deliver to the selected address",
                )) {
                  OrdersHelper.showOutOfRadiusDialog(context);
                  context.read<OrdersBloc>().add(FetchOrders());
                } else {
                  CustomSnackBar.show(
                    context,
                    message: state.message,
                    isError: true,
                  );
                }
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Banner
                      OrderDetailsStatusBanner(order: currentOrder),
                      SizedBox(height: 16.h),

                      // Return Progress Tracker
                      if (isDelivered && hasReturnRequest) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16.r),
                            border: isDark
                                ? Border.all(
                                    color: CustomerAppColors.darkBorder,
                                  )
                                : null,
                          ),
                          child: ReturnProgressTracker(order: currentOrder),
                        ),
                        SizedBox(height: 16.h),
                      ],

                      // Delivery Timeline only if not delivered and not cancelled
                      if (!isDelivered && !isCancelled) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16.r),
                            border: isDark
                                ? Border.all(
                                    color: CustomerAppColors.darkBorder,
                                  )
                                : null,
                          ),
                          child: DeliveryProgressTracker(order: currentOrder),
                        ),
                        SizedBox(height: 16.h),
                      ],

                      // Order Items Section
                      OrderDetailsItemsSection(order: currentOrder),
                      SizedBox(height: 24.h),

                      // Shipping Details Section
                      OrderDetailsShippingSection(order: currentOrder),
                      SizedBox(height: 24.h),

                      // Payment Summary Section
                      OrderDetailsPaymentSection(order: currentOrder),
                      SizedBox(height: 32.h),

                      // Reorder Item Button
                      OrderDetailsReorderButton(order: currentOrder),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
