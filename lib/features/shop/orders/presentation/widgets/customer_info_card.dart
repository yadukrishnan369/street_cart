import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/shared/widgets/custom_alert_dialog.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Customer Info Card
class CustomerInfoCard extends StatelessWidget {
  final OrderModel order;

  const CustomerInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          // Card Title
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
            color: isDark
                ? ShopAppColors.darkSurface
                : const Color(0xFFF1F5F9).withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isDark ? ShopAppColors.darkBorder : Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              // Profile Icon
              CircleAvatar(
                radius: 28.r,
                backgroundColor: isDark
                    ? ShopAppColors.darkBorder
                    : const Color(0xFFE2E8F0),
                child: Icon(
                  Icons.person,
                  color: ShopAppColors.primary,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Name from Delivery Address Details
                    Text(
                      order.deliveryAddress.fullName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? ShopAppColors.darkTextPrimary
                            : ShopAppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Delivery Address Phone Number
                    Text(
                      order.deliveryAddress.phone.isNotEmpty
                          ? order.deliveryAddress.phone
                          : '..........',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: order.deliveryAddress.phone.isEmpty
                    ? null
                    : () {
                        // Confirmation for Call the Customer
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
            color: isDark ? ShopAppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isDark ? ShopAppColors.darkBorder : Colors.grey[200]!,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? ShopAppColors.darkBorder
                      : const Color(0xFFF1F5F9),
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
                        color: isDark
                            ? ShopAppColors.darkTextSecondary
                            : Colors.grey[400],
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    // Full Shipping Address Details
                    Text(
                      '${order.deliveryAddress.addressLine1}, ${order.deliveryAddress.addressLine2.isNotEmpty ? "${order.deliveryAddress.addressLine2}, " : ""}${order.deliveryAddress.city} - ${order.deliveryAddress.pincode}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark
                            ? ShopAppColors.darkTextPrimary
                            : ShopAppColors.textPrimary,
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
