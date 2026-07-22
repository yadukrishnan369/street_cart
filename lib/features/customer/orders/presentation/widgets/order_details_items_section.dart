import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';
import 'package:street_cart/shared/widgets/product_image_placeholder.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/customer_order_status.dart';
import 'package:street_cart/features/customer/orders/presentation/utils/orders_helper.dart';
import 'package:street_cart/features/customer/orders/presentation/pages/return_request_page.dart';

// Order Details Items Section
class OrderDetailsItemsSection extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsItemsSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.status.toLowerCase() == 'delivered';

    return Column(
      children: order.items.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
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
                        // Product Name
                        Text(
                          item.productName,
                          style: TextStyle(
                            color: CustomerAppColors.textPrimary,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        // Color and Size
                        Text(
                          'Size: ${item.selectedSize ?? "M"}  |  Color: ${item.selectedColor ?? "Default"}',
                          style: TextStyle(
                            color: Colors.grey[400],
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
                                color: CustomerAppColors.textPrimary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Price
                            Text(
                              '₹${(item.price * 1.15).toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.grey[400],
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
                          CustomSnackBar.show(
                            context,
                            message: 'Review for ${item.productName} clicked!',
                          );
                        },
                        icon: Icon(
                          Icons.star_border,
                          size: 16.sp,
                          color: CustomerAppColors.textPrimary,
                        ),
                        label: Text(
                          'Write a Review',
                          style: TextStyle(
                            color: CustomerAppColors.textPrimary,
                            fontSize: 13.sp,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[200]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                    // Return Button
                    if (OrdersHelper.isReturnEligible(order) &&
                        (order.returnStatus == null ||
                            order.returnStatus!.isEmpty)) ...[
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
                            color: CustomerAppColors.textPrimary,
                          ),
                          label: Text(
                            'Return Item',
                            style: TextStyle(
                              color: CustomerAppColors.textPrimary,
                              fontSize: 13.sp,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[200]!),
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
                        color: Colors.grey[400],
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
                      side: BorderSide(color: Colors.grey[300]!),
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
