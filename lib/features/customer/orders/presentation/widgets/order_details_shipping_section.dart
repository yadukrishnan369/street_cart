import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

class OrderDetailsShippingSection extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsShippingSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SHIPPING DETAILS',
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: const Color(0xFF5E5CE6),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.deliveryAddress.fullName,
                      style: TextStyle(
                        color: CustomerAppColors.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${order.deliveryAddress.addressLine1}, ${order.deliveryAddress.addressLine2}\n${order.deliveryAddress.city}, ${order.deliveryAddress.pincode}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13.sp,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Phone: ${order.deliveryAddress.phone}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
