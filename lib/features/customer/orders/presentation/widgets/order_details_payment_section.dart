import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

// Order Details Payment Section
class OrderDetailsPaymentSection extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPaymentSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          'PAYMENT SUMMARY',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w900,
            color: Colors.grey[600],
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
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
            children: [
              Row(
                children: [
                  Icon(Icons.payment, color: Colors.grey[600], size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Payment Method',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
                  ),
                  const Spacer(),
                  // Payment Method
                  Text(
                    order.paymentMethod.toUpperCase(),
                    style: TextStyle(
                      color: CustomerAppColors.textPrimary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Divider(height: 24.h, color: Colors.grey[100]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Number of Order Item
                  Text(
                    'Number of Items',
                    style: TextStyle(color: Colors.grey[400], fontSize: 13.sp),
                  ),
                  Text(
                    '${order.items.length}',
                    style: TextStyle(
                      color: CustomerAppColors.textPrimary,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Subtotal
                  Text(
                    'Subtotal',
                    style: TextStyle(
                      color: CustomerAppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: CustomerAppColors.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Divider(height: 24.h, color: Colors.grey[100]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Text(
                    'Order Total',
                    style: TextStyle(
                      color: CustomerAppColors.textPrimary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Order Total Amount
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: const Color(0xFF5E5CE6),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
