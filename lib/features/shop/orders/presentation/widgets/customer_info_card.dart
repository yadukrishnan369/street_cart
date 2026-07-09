import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

class CustomerInfoCard extends StatelessWidget {
  final OrderModel order;

  const CustomerInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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

        // Customer Name Card
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9).withOpacity(0.4),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: const Color(0xFFE2E8F0),
                child: Icon(Icons.person, color: Colors.grey[600], size: 28.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.deliveryAddress.fullName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order.deliveryAddress.phone,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogCtx) => CustomAlertDialog(
                      title: 'Call Customer',
                      content:
                          'Do you want to make a call to ${order.deliveryAddress.fullName}?',
                      primaryActionLabel: 'Call',
                      onPrimaryAction: () {
                        Navigator.pop(dialogCtx);
                        sl<CommunicationService>().makeCall(
                          order.deliveryAddress.phone,
                        );
                      },
                      secondaryActionLabel: 'Cancel',
                      onSecondaryAction: () => Navigator.pop(dialogCtx),
                      icon: Icons.phone,
                      iconColor: ShopAppColors.primary,
                      primaryActionColor: ShopAppColors.primary,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: const BoxDecoration(
                    color: ShopAppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.phone, color: Colors.white, size: 20.sp),
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
                    Text(
                      '${order.deliveryAddress.addressLine1}, ${order.deliveryAddress.addressLine2.isNotEmpty ? "${order.deliveryAddress.addressLine2}, " : ""}${order.deliveryAddress.city} - ${order.deliveryAddress.pincode}',
                      style: TextStyle(
                        fontSize: 14.sp,
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
