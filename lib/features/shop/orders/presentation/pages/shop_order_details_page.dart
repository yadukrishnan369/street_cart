import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_order_status.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/customer_info_card.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/item_summary_card.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/order_timeline_tracker.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_order_delivered_banner.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_order_details_action_button.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/refund_success_widget.dart';
import 'package:street_cart/shared/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_order_cancelled_banner.dart';

// Shop Order Details Page
class ShopOrderDetailsPage extends StatelessWidget {
  final OrderModel order;
  final String shopId;
  final bool isCancelledView;

  const ShopOrderDetailsPage({
    super.key,
    required this.order,
    required this.shopId,
    this.isCancelledView = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final orderIdPrefix = ShopOrdersHelper.getOrderIdPrefix(order.id);

    final productIds = order.items.map((item) => item.productId).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ShopOrdersBloc>().add(CheckProductsStatusEvent(productIds));
    });

    return BlocListener<ShopOrdersBloc, ShopOrdersState>(
      listener: (context, state) {
        // Get Current Order
        final updated = ShopOrdersHelper.getCurrentOrder(
          state: state,
          fallbackOrder: order,
        );
        if (updated.status != order.status) {
          if (ModalRoute.of(context)?.isCurrent == true) {
            Navigator.pop(context);
          }
        }
      },
      child: BlocBuilder<ShopOrdersBloc, ShopOrdersState>(
        builder: (context, state) {
          // Get Current Order
          final currentOrder = ShopOrdersHelper.getCurrentOrder(
            state: state,
            fallbackOrder: order,
          );

          final nextStatusLabel = ShopOrdersHelper.getNextStatusActionLabel(
            ShopOrderStatus.fromString(currentOrder.status),
          );
          final nextStatus = ShopOrdersHelper.getNextStatus(
            ShopOrderStatus.fromString(currentOrder.status),
          );

          final cardData = ShopOrdersHelper.getShopOrderCardData(
            order: currentOrder,
            shopId: shopId,
            isCancelledView: isCancelledView,
          );
          final totalAmount =
              (cardData['totalAmount'] as double?) ?? currentOrder.totalAmount;

          final isCOD =
              currentOrder.paymentMethod.toLowerCase().contains('cod') ||
              currentOrder.paymentMethod.toLowerCase().contains('cash');
          final isCancelled =
              currentOrder.status.toLowerCase() == 'cancelled' ||
              isCancelledView;

          return Stack(
            children: [
              Scaffold(
                backgroundColor: theme.scaffoldBackgroundColor,
                appBar: AppBar(
                  backgroundColor: isDark
                      ? ShopAppColors.darkBackground
                      : Colors.white,
                  centerTitle: true,
                  elevation: isDark ? null : 1.0,
                  shape: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? ShopAppColors.darkBorder
                          : ShopAppColors.border.withValues(alpha: 1.0),
                      width: 0.5,
                    ),
                  ),
                  // Page Header with Order ID
                  title: Text(
                    'Order #ORD-$orderIdPrefix',
                    style: TextStyle(
                      color: isDark
                          ? ShopAppColors.darkTextPrimary
                          : ShopAppColors.textPrimary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDark
                          ? ShopAppColors.darkTextPrimary
                          : ShopAppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isCancelled)
                        ShopOrderCancelledBanner(
                          order: currentOrder,
                          totalAmount: totalAmount,
                        )
                      else
                        ShopOrderDeliveredBanner(order: currentOrder),
                      SizedBox(height: 8.h),
                      // Customer Info Card
                      CustomerInfoCard(order: currentOrder),
                      SizedBox(height: 16.h),
                      // Item Summary Card
                      ItemSummaryCard(
                        order: currentOrder,
                        shopId: shopId,
                        isCancelledView: isCancelledView,
                      ),
                      SizedBox(height: 16.h),
                      // Order Timeline Tracker
                      if (!isCancelled) ...[
                        OrderTimelineTracker(order: currentOrder),
                      ],
                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
                // Shop Order Details Action Button
                bottomSheet:
                    (isCancelled &&
                        !isCOD &&
                        (currentOrder.refundStatus == 'pending' ||
                            currentOrder.items.any(
                              (item) =>
                                  item.shopId == shopId &&
                                  item.status == 'cancelled' &&
                                  item.refundStatus == 'pending',
                            )))
                    ? Container(
                        padding: EdgeInsets.all(16.w),
                        color: isDark
                            ? ShopAppColors.darkSurface
                            : Colors.white,
                        child: SafeArea(
                          child: PrimaryButton(
                            prefixIcon: const Icon(
                              Icons.currency_rupee,
                              color: Colors.white,
                            ),
                            text: 'Process Refund',
                            backgroundColor: ShopAppColors.primary,
                            height: 55.h,
                            onPressed: () {
                              ShopOrdersHelper.showStatusChangeConfirmation(
                                context: context,
                                statusLabel: 'Process Refund',
                                onConfirm: () {
                                  context.read<ShopOrdersBloc>().add(
                                    InitiateRefundEvent(
                                      orderId: currentOrder.id,
                                      refundAmount: totalAmount,
                                      paymentMethod: currentOrder.paymentMethod,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      )
                    : (nextStatusLabel != null &&
                          nextStatus != null &&
                          !isCancelled)
                    ? ShopOrderDetailsActionButton(
                        order: currentOrder,
                        shopId: shopId,
                      )
                    : null,
              ),
              if (state.refundStatus == 'processing')
                Positioned.fill(
                  child: Container(
                    color: Colors.black26,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ShopAppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              if (state.refundStatus == 'success')
                Positioned.fill(
                  child: RefundSuccessWidget(
                    amount: totalAmount,
                    onDismiss: () {
                      context.read<ShopOrdersBloc>().add(
                        const ResetRefundStatusEvent(),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
