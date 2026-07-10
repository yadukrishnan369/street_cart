import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/shared/widgets/customer_image_placeholder.dart';

class CustomerInfoCard extends StatelessWidget {
  final OrderModel order;
  final String customerName;
  final String customerEmail;

  const CustomerInfoCard({
    super.key,
    required this.order,
    required this.customerName,
    required this.customerEmail,
  });

  @override
  Widget build(BuildContext context) {
    final email = customerEmail.isNotEmpty ? customerEmail : '';
    final phone = order.deliveryAddress.phone;
    final address =
        '${order.deliveryAddress.addressLine1}, ${order.deliveryAddress.addressLine2}, ${order.deliveryAddress.city}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: InkWell(
        onTap: () {
          context.push('/customers/${order.customerId}');
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: const Color(0xFF7B2CBF),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Customer Information',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E1E2F),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF9FAFC),
                    ),
                    child: const CustomerImagePlaceholder(size: 50),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E1E2F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              const Divider(color: Color(0xFFE8E7ED), thickness: 1.2),
              SizedBox(height: 20.h),
              _buildInfoRow(Icons.mail_outlined, email),
              SizedBox(height: 12.h),
              _buildInfoRow(Icons.phone_outlined, phone),
              SizedBox(height: 12.h),
              _buildInfoRow(Icons.location_on_outlined, address),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF8A8A9E), size: 16.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6C6C80)),
          ),
        ),
      ],
    );
  }
}
