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
import 'package:street_cart/features/customer/orders/presentation/widgets/order_details_status_banner.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/order_details_items_section.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/order_details_shipping_section.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/order_details_payment_section.dart';
import 'package:street_cart/features/customer/orders/presentation/widgets/order_details_reorder_button.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final orderIdText = OrdersHelper.getOrderIdSuffix(order.id);
    final activeColor = CustomerAppColors.primary;

    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        final currentOrder = OrdersHelper.getCurrentOrder(state, order);

        final status = CustomerOrderStatus.fromString(currentOrder.status);
        final isDelivered = OrdersHelper.isDelivered(status);
        final isCancelled = OrdersHelper.isCancelled(status);

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  'Order Details',
                  style: TextStyle(
                    color: CustomerAppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
              icon: const Icon(Icons.arrow_back, color: Colors.black),
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
              } else if (state is OrderAddressUpdateSuccess) {
                CustomSnackBar.show(
                  context,
                  message: 'Delivery address updated successfully.',
                );
                context.read<OrdersBloc>().add(FetchOrders());
              } else if (state is OrdersFailure) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
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
                      // Top Status Banner
                      OrderDetailsStatusBanner(order: currentOrder),
                      SizedBox(height: 16.h),

                      // Delivery Timeline only if not delivered and not cancelled
                      if (!isDelivered && !isCancelled) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
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
