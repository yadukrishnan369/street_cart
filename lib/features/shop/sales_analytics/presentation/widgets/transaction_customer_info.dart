import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/utils/sales_analytics_helper.dart';

// Transaction Customer Info
class TransactionCustomerInfo extends StatelessWidget {
  final OrderModel order;

  const TransactionCustomerInfo({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          // Title
          child: Text(
            'CUSTOMER INFORMATION',
            style: TextStyle(
              color: ShopAppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
              letterSpacing: 0.5,
            ),
          ),
        ),
        // Customer Profile Avatar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: const Color(0xFFE2E8F0),
                child: Icon(
                  Icons.person,
                  color: ShopAppColors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivered Customer Name
                    Text(
                      order.deliveryAddress.fullName,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Delivered Addresss
                    Text(
                      order.deliveryAddress.phone,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Customer Phone Call
              GestureDetector(
                onTap: () => SalesAnalyticsHelper.callCustomer(
                  context,
                  order.deliveryAddress.fullName,
                  order.deliveryAddress.phone,
                ),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: ShopAppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.phone, color: Colors.white, size: 18.sp),
                ),
              ),
            ],
          ),
        ),

        // Shipping Address Card
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on,
                  color: ShopAppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'SHIPPING ADDRESS',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Shipping Address
                    Text(
                      '${order.deliveryAddress.addressLine1}, ${order.deliveryAddress.addressLine2.isNotEmpty ? "${order.deliveryAddress.addressLine2}, " : ""}${order.deliveryAddress.city} - ${order.deliveryAddress.pincode}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF1E293B),
                        height: 1.35,
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
