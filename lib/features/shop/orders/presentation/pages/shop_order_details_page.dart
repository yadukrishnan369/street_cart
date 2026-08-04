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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';

// Shop Order Details Page
class ShopOrderDetailsPage extends StatelessWidget {
  final OrderModel order;
  final String shopId;

  const ShopOrderDetailsPage({
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

          return Scaffold(
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
                  // Shop Order Delivered Banner
                  ShopOrderDeliveredBanner(order: currentOrder),
                  SizedBox(height: 8.h),
                  // Customer Info Card
                  CustomerInfoCard(order: currentOrder),
                  SizedBox(height: 16.h),
                  // Item Summary Card
                  ItemSummaryCard(order: currentOrder, shopId: shopId),
                  SizedBox(height: 16.h),
                  // Order Timeline Tracker
                  OrderTimelineTracker(order: currentOrder),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
            // Shop Order Details Action Button
            bottomSheet: (nextStatusLabel != null && nextStatus != null)
                ? ShopOrderDetailsActionButton(
                    order: currentOrder,
                    shopId: shopId,
                  )
                : null,
          );
        },
      ),
    );
  }
}
