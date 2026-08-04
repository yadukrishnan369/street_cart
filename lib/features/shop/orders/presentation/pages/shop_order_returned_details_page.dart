import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/customer_info_card.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/returned_item_info_card.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/return_reason_card.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/shop_return_progress_tracker.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/return_status_banner.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/return_action_button.dart';
import 'package:street_cart/features/shop/orders/presentation/widgets/refund_success_widget.dart';

// Shop Order Returned Details Page
class ShopOrderReturnedDetailsPage extends StatelessWidget {
  final OrderModel order;
  final String shopId;

  const ShopOrderReturnedDetailsPage({
    super.key,
    required this.order,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final orderIdPrefix = ShopOrdersHelper.getOrderIdPrefix(order.id);

    return BlocListener<ShopOrdersBloc, ShopOrdersState>(
      listener: (context, state) {
        // Get Current Order
        final updated = ShopOrdersHelper.getCurrentOrder(
          state: state,
          fallbackOrder: order,
        );
        if (updated.returnStatus != order.returnStatus) {
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
          final returnStatus = (currentOrder.returnStatus ?? '').toLowerCase();
          final refundStatus = currentOrder.refundStatus;

          final returnedItems = ShopOrdersHelper.getReturnedItems(
            order: currentOrder,
            shopId: shopId,
          );
          final double refundAmount = ShopOrdersHelper.calculateRefundAmount(
            returnedItems,
          );

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
                    'Returned Order #ORD-$orderIdPrefix',
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
                      // Return Status Banner
                      ReturnStatusBanner(
                        returnStatus: returnStatus,
                        refundStatus: refundStatus,
                        refundAmount: refundAmount,
                      ),
                      SizedBox(height: 8.h),
                      // Return Reason Card
                      ReturnReasonCard(order: currentOrder, shopId: shopId),
                      SizedBox(height: 16.h),
                      // Returned Item Info Card
                      ReturnedItemInfoCard(order: currentOrder, shopId: shopId),
                      SizedBox(height: 16.h),
                      // Customer Info Card
                      CustomerInfoCard(order: currentOrder),
                      SizedBox(height: 16.h),
                      // Shop Return Progress Tracker
                      ShopReturnProgressTracker(order: currentOrder),
                      SizedBox(height: 120.h),
                    ],
                  ),
                ),
                // Return Action Button
                bottomSheet: ReturnActionButton(
                  returnStatus: returnStatus,
                  orderId: order.id,
                  shopId: shopId,
                  refundStatus: refundStatus,
                  refundAmount: refundAmount,
                  paymentMethod: currentOrder.paymentMethod,
                ),
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
                    amount: refundAmount,
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
