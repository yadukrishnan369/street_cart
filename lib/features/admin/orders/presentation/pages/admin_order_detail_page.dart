import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/orders/presentation/bloc/admin_orders_bloc.dart';
import 'package:street_cart/features/admin/orders/presentation/bloc/admin_orders_event.dart';
import 'package:street_cart/features/admin/orders/presentation/bloc/admin_orders_state.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';
import 'package:street_cart/features/admin/orders/presentation/widgets/tracking_details_card.dart';
import 'package:street_cart/features/admin/orders/presentation/widgets/order_product_details_card.dart';
import 'package:street_cart/features/admin/orders/presentation/widgets/order_payment_summary_card.dart';
import 'package:street_cart/features/admin/orders/presentation/widgets/customer_info_card.dart';
import 'package:street_cart/features/admin/orders/presentation/widgets/shop_info_card.dart';
import 'package:street_cart/features/admin/orders/presentation/widgets/profit_info_card.dart';
import 'package:street_cart/features/admin/orders/presentation/widgets/admin_order_detail_header.dart';
import 'package:street_cart/features/admin/orders/presentation/widgets/shimmer/admin_order_detail_shimmer.dart';

// Admin Order Detail Page
class AdminOrderDetailPage extends StatelessWidget {
  final String orderId;

  const AdminOrderDetailPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminOrdersBloc>()..add(LoadAdminOrders()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: BlocBuilder<AdminOrdersBloc, AdminOrdersState>(
            builder: (context, state) {
              if (state is AdminOrdersLoading) {
                return const AdminOrderDetailShimmer();
              }
              if (state is AdminOrdersLoaded) {
                final order = state.orders.firstWhere(
                  (o) =>
                      o.id == orderId ||
                      AdminOrdersHelper.getDisplayOrderId(o.id) == orderId,
                  orElse: () => null as dynamic,
                );
                final formattedId = AdminOrdersHelper.getDisplayOrderId(
                  order.id,
                );
                final shopName = AdminOrdersHelper.getShopName(
                  order,
                  state.shopNames,
                );
                final shopId = order.items.isNotEmpty
                    ? order.items.first.shopId
                    : '';
                final shopProfile = state.shopProfiles[shopId];
                final timeStr = DateFormatter.formatToTime(order.createdAt);
                final dateStr = DateFormatter.formatToReadableDate(
                  order.createdAt,
                );

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 40.w : 20.w,
                        vertical: 32.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          TextButton.icon(
                            onPressed: () => context.pop(),
                            icon: Icon(
                              Icons.arrow_back,
                              size: 16.sp,
                              color: AdminAppColors.primaryColor,
                            ),
                            label: Text(
                              'Back to Orders',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AdminAppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Admin Order Detail Header
                          AdminOrderDetailHeader(
                            order: order,
                            formattedId: formattedId,
                            dateStr: dateStr,
                            timeStr: timeStr,
                          ),
                          SizedBox(height: 24.h),
                          if (isWide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Tracking Details Card
                                      TrackingDetailsCard(order: order),
                                      SizedBox(height: 24.h),
                                      // Order Product Details Card
                                      OrderProductDetailsCard(order: order),
                                      SizedBox(height: 24.h),
                                      // Order Payment Summary Card
                                      OrderPaymentSummaryCard(order: order),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 24.w),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Customer Info Card
                                      CustomerInfoCard(
                                        order: order,
                                        customerName:
                                            state.customerNames[order
                                                .customerId] ??
                                            order.deliveryAddress.fullName,
                                        customerEmail:
                                            state.customerEmails[order
                                                .customerId] ??
                                            '',
                                      ),
                                      SizedBox(height: 24.h),
                                      // Shop Info Cards
                                      ShopInfoCard(
                                        shopName: shopName,
                                        shop: shopProfile,
                                      ),
                                      SizedBox(height: 24.h),
                                      ProfitInfoCard(order: order),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tracking Details Card
                                TrackingDetailsCard(order: order),
                                SizedBox(height: 24.h),
                                // Order Product Details Card
                                OrderProductDetailsCard(order: order),
                                SizedBox(height: 24.h),
                                // Order Payment Summary Card
                                OrderPaymentSummaryCard(order: order),
                                SizedBox(height: 24.h),
                                // Customer Info Card
                                CustomerInfoCard(
                                  order: order,
                                  customerName:
                                      state.customerNames[order.customerId] ??
                                      order.deliveryAddress.fullName,
                                  customerEmail:
                                      state.customerEmails[order.customerId] ??
                                      '',
                                ),
                                SizedBox(height: 24.h),
                                // Shop Info Card
                                ShopInfoCard(
                                  shopName: shopName,
                                  shop: shopProfile,
                                ),
                                SizedBox(height: 24.h),
                                // Profit Info Card
                                ProfitInfoCard(order: order),
                              ],
                            ),
                        ],
                      ),
                    );
                  },
                );
              }
              if (state is AdminOrdersFailure) {
                return Center(
                  child: Text(
                    'Failed to load details: ${state.message}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
