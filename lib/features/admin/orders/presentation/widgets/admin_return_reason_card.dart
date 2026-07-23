import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

// Admin Return Reason Card
class AdminReturnReasonCard extends StatelessWidget {
  final OrderModel order;

  const AdminReturnReasonCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final returnedItems = order.items
        .where(
          (item) => item.returnStatus != null && item.returnStatus!.isNotEmpty,
        )
        .toList();
    final isMultiple = returnedItems.length > 1;

    if (returnedItems.isEmpty &&
        (order.returnReason == null || order.returnReason!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF0EFF5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'RETURN DETAILS',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1E2F),
            ),
          ),
          SizedBox(height: 16.h),
          if (returnedItems.isEmpty) ...[
            // Reason
            Text(
              'Reason for Return',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E1E2F),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              order.returnReason ?? 'No reason provided',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),
            if (order.returnDetails != null &&
                order.returnDetails!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              // Additional Info
              Text(
                'Additional Description',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                order.returnDetails!,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              ),
            ],
          ] else if (!isMultiple) ...[
            Text(
              'Reason for Return',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E1E2F),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              returnedItems.first.returnReason ?? 'No reason provided',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
            ),
            if (returnedItems.first.returnDetails != null &&
                returnedItems.first.returnDetails!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                'Additional Description',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                returnedItems.first.returnDetails!,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              ),
            ],
          ] else ...[
            ...List.generate(returnedItems.length, (index) {
              final item = returnedItems[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                      color: AdminAppColors.primaryColor.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Reason for Return',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E1E2F),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item.returnReason ?? 'No reason provided',
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                  ),
                  if (item.returnDetails != null &&
                      item.returnDetails!.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Text(
                      'Additional Description',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E1E2F),
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
    );
  }
}
