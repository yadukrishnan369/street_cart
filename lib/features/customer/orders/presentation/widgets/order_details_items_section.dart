import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/customer_order_status.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';
import 'package:street_cart/features/customer/orders/presentation/pages/return_request_page.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/customer/review/presentation/bloc/review_bloc.dart';
import 'package:street_cart/features/customer/review/presentation/pages/review_page.dart';

// Order Details Items Section
class OrderDetailsItemsSection extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsItemsSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isDelivered = order.status.toLowerCase() == 'delivered';

    return Column(
      children: order.items.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: isDark
                ? Border.all(color: CustomerAppColors.darkBorder)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CachedNetworkImage(
                      imageUrl: item.productImage,
                      width: 64.w,
                      height: 64.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ProductImagePlaceholder(
                        width: 64.w,
                        height: 64.w,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      errorWidget: (context, url, error) =>
                          ProductImagePlaceholder(
                            width: 64.w,
                            height: 64.w,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name & View
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.productName,
                                style: TextStyle(
                                  color: isDark
                                      ? CustomerAppColors.darkTextPrimary
                                      : CustomerAppColors.textPrimary,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {
                                OrdersHelper.navigateToProductDetails(
                                  context: context,
                                  productId: item.productId,
                                  shopId: item.shopId,
                                  selectedColor: item.selectedColor,
                                  selectedSize: item.selectedSize,
                                );
                              },
                              child: Text(
                                'View',
                                style: TextStyle(
                                  color: CustomerAppColors.primary,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        // Color and Size
                        Text(
                          'Size: ${item.selectedSize ?? "M"}  |  Color: ${item.selectedColor ?? "Default"}',
                          style: TextStyle(
                            color: isDark
                                ? CustomerAppColors.darkTextSecondary
                                : Colors.grey[400],
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            // Price
                            Text(
                              '₹${item.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: isDark
                                    ? CustomerAppColors.darkTextPrimary
                                    : CustomerAppColors.textPrimary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Original Price
                            Text(
                              '₹${(item.price * 1.15).toStringAsFixed(0)}',
                              style: TextStyle(
                                color: isDark
                                    ? CustomerAppColors.darkTextSecondary
                                    : Colors.grey[400],
                                fontSize: 12.sp,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isDelivered) ...[
                SizedBox(height: 16.h),
                Row(
                  children: [
                    // Review Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => sl<ReviewBloc>(),
                                child: ReviewPage(
                                  productId: item.productId,
                                  productName: item.productName,
                                  productImage: item.productImage,
                                  shopId: item.shopId,
                                  selectedSize: item.selectedSize,
                                  selectedColor: item.selectedColor,
                                  price: item.price,
                                ),
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.star_border,
                          size: 16.sp,
                          color: isDark
                              ? CustomerAppColors.darkTextPrimary
                              : CustomerAppColors.textPrimary,
                        ),
                        label: Text(
                          'Write a Review',
                          style: TextStyle(
                            color: isDark
                                ? CustomerAppColors.darkTextPrimary
                                : CustomerAppColors.textPrimary,
                            fontSize: 13.sp,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark
                                ? CustomerAppColors.darkBorder
                                : Colors.grey[200]!,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                    // Return Button / Return Status Badge
                    if (item.returnStatus != null &&
                        item.returnStatus!.isNotEmpty) ...[
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isDark
                                ? ((item.returnStatus == 'return_picked' ||
                                          item.returnStatus == 'returned')
                                      ? const Color(0xFF1B3A2B)
                                      : item.returnStatus == 'return_confirmed'
                                      ? const Color(0xFF1B2D3A)
                                      : const Color(0xFF3A2E1B))
                                : ((item.returnStatus == 'return_picked' ||
                                          item.returnStatus == 'returned')
                                      ? const Color(0xFFE8F5E9)
                                      : item.returnStatus == 'return_confirmed'
                                      ? const Color(0xFFE3F2FD)
                                      : const Color(0xFFFFF3E0)),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isDark
                                  ? ((item.returnStatus == 'return_picked' ||
                                            item.returnStatus == 'returned')
                                        ? const Color(0xFF2E6B47)
                                        : item.returnStatus ==
                                              'return_confirmed'
                                        ? const Color(0xFF2E4D6B)
                                        : const Color(0xFF6B4E2E))
                                  : ((item.returnStatus == 'return_picked' ||
                                            item.returnStatus == 'returned')
                                        ? const Color(0xFFC8E6C9)
                                        : item.returnStatus ==
                                              'return_confirmed'
                                        ? const Color(0xFFBBDEFB)
                                        : const Color(0xFFFFE0B2)),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              (item.returnStatus == 'return_picked' ||
                                      item.returnStatus == 'returned')
                                  ? 'Returned'
                                  : item.returnStatus == 'return_confirmed'
                                  ? 'Return Confirmed'
                                  : 'Return Requested',
                              style: TextStyle(
                                color:
                                    (item.returnStatus == 'return_picked' ||
                                        item.returnStatus == 'returned')
                                    ? CustomerAppColors.success
                                    : item.returnStatus == 'return_confirmed'
                                    ? CustomerAppColors.primary
                                    : CustomerAppColors.error,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else if (OrdersHelper.isReturnEligible(order)) ...[
                      SizedBox(width: 12.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<OrdersBloc>(),
                                  child: ReturnRequestPage(
                                    order: order,
                                    item: item,
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.reply,
                            size: 16.sp,
                            color: isDark
                                ? CustomerAppColors.darkTextPrimary
                                : CustomerAppColors.textPrimary,
                          ),
                          label: Text(
                            'Return Item',
                            style: TextStyle(
                              color: isDark
                                  ? CustomerAppColors.darkTextPrimary
                                  : CustomerAppColors.textPrimary,
                              fontSize: 13.sp,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: isDark
                                  ? CustomerAppColors.darkBorder
                                  : Colors.grey[200]!,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                // Return Eligible Date
                if (OrdersHelper.isReturnEligible(order) &&
                    order.deliveredAt != null &&
                    (order.returnStatus == null ||
                        order.returnStatus!.isEmpty)) ...[
                  SizedBox(height: 8.h),
                  Center(
                    child: Text(
                      'Eligible for return until ${DateFormatter.formatToReadableDate(order.deliveredAt!.add(const Duration(days: 4)))}',
                      style: TextStyle(
                        color: isDark
                            ? CustomerAppColors.darkTextSecondary
                            : Colors.grey[400],
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
              ],
              // Cancel Button
              if (OrdersHelper.isCancellable(
                CustomerOrderStatus.fromString(order.status),
              )) ...[
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  height: 38.h,
                  child: OutlinedButton(
                    onPressed: () {
                      OrdersHelper.showCancelOrderItemDialog(
                        context: context,
                        orderId: order.id,
                        orderItemId: item.id,
                        ordersBloc: context.read<OrdersBloc>(),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark
                            ? CustomerAppColors.darkBorder
                            : Colors.grey[300]!,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      'Cancel Item',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 238, 160, 160),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
