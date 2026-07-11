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
    final orderIdPrefix = ShopOrdersHelper.getOrderIdPrefix(order.id);
    final nextStatusLabel = ShopOrdersHelper.getNextStatusActionLabel(
      ShopOrderStatus.fromString(order.status),
    );
    final nextStatus = ShopOrdersHelper.getNextStatus(
      ShopOrderStatus.fromString(order.status),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Text(
          'Order #ORD-$orderIdPrefix',
          style: TextStyle(
            color: ShopAppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShopOrderDeliveredBanner(order: order),
            SizedBox(height: 8.h),
            CustomerInfoCard(order: order),
            SizedBox(height: 16.h),
            ItemSummaryCard(order: order, shopId: shopId),
            SizedBox(height: 16.h),
            OrderTimelineTracker(order: order),
            SizedBox(height: 120.h),
          ],
        ),
      ),
      bottomSheet: (nextStatusLabel != null && nextStatus != null)
          ? ShopOrderDetailsActionButton(order: order, shopId: shopId)
          : null,
    );
  }
}
