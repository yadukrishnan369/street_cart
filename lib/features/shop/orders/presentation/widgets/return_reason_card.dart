import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/orders/presentation/utils/shop_orders_helper.dart';

// Return Reason Card
class ReturnReasonCard extends StatelessWidget {
  final OrderModel order;
  final String shopId;

  const ReturnReasonCard({
    super.key,
    required this.order,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    // Get Returned Items
    final returnedItems = ShopOrdersHelper.getReturnedItems(
      order: order,
      shopId: shopId,
    );

    final isMultiple = returnedItems.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          // Title
          child: Text(
            'RETURN DETAILS',
            style: TextStyle(
              color: ShopAppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMultiple) ...[
                Text(
                  'Reason for Return',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: ShopAppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  returnedItems.first.returnReason ??
                      order.returnReason ??
                      'No reason provided',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
                if ((returnedItems.first.returnDetails != null &&
                        returnedItems.first.returnDetails!.isNotEmpty) ||
                    (order.returnDetails != null &&
                        order.returnDetails!.isNotEmpty)) ...[
                  SizedBox(height: 12.h),
                  Text(
                    'Additional Description',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: ShopAppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    returnedItems.first.returnDetails ?? order.returnDetails!,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                  ),
                ],
              ] else ...[
                ...List.generate(returnedItems.length, (index) {
                  final item = returnedItems[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        item.productName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: ShopAppColors.primary.withAlpha(180),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Reason
                      Text(
                        'Reason for Return',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: ShopAppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        item.returnReason ?? 'No reason provided',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      if (item.returnDetails != null &&
                          item.returnDetails!.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        // Additional Description
                        Text(
                          'Additional Description',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: ShopAppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item.returnDetails!,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                      if (index < returnedItems.length - 1) ...[
                        SizedBox(height: 12.h),
                        const Divider(height: 1.0, thickness: 0.2),
                        SizedBox(height: 12.h),
                      ],
                    ],
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
