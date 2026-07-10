import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';

class OrderPaymentSummaryCard extends StatelessWidget {
  final OrderModel order;

  const OrderPaymentSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final subtotal = AdminOrdersHelper.calculateSubtotal(order);
    final commission = AdminOrdersHelper.calculateCommission(order);
    final deduction = AdminOrdersHelper.calculateAfterDeduction(
      subtotal,
      commission,
    );
    final paymentStatus = AdminOrdersHelper.getPaymentStatus(order);
    final isPaid = paymentStatus == 'PAID';

    final subtotalStr = '₹${PriceUtils.formatPrice(subtotal)}';
    final commStr = '₹${PriceUtils.formatPrice(commission)}';
    final deductionStr = '₹${PriceUtils.formatPrice(deduction)}';
    final grandTotalStr = '₹${PriceUtils.formatPrice(order.totalAmount)}';

    // Calculate commission percentage
    final double commissionPercentage =
        AdminOrdersHelper.calculateCommissionPercentage(order);
    final commissionPercentStr = commissionPercentage > 0
        ? ' (${commissionPercentage.toStringAsFixed(1)}%)'
        : '';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              'Payment Summary',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E1E2F),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                _buildSummaryRow('Subtotal', subtotalStr),
                SizedBox(height: 12.h),
                _buildSummaryRow(
                  'Commission$commissionPercentStr',
                  commStr,
                  valueColor: const Color(0xFF137333),
                ),
                SizedBox(height: 12.h),
                _buildSummaryRow('After Deduction', deductionStr),
                SizedBox(height: 16.h),
                const Divider(color: Color(0xFFE8E7ED), thickness: 1.2),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Grand Total',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E1E2F),
                      ),
                    ),
                    Text(
                      grandTotalStr,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: AdminAppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          // show payments Label
          if (order.paymentMethod.toLowerCase() != 'cod' &&
              order.paymentMethod.toLowerCase() != 'cash on delivery')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: const BoxDecoration(
                color: Color(0xFFF0EEFC),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.payment_outlined,
                        color: const Color(0xFF6C6C80),
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Payment Via ${order.paymentMethod.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6C6C80),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color:
                            (isPaid
                                    ? const Color(0xFF137333)
                                    : const Color(0xFFE8C100))
                                .withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      paymentStatus,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: isPaid
                            ? const Color(0xFF137333)
                            : const Color(0xFFB8860B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (order.paymentMethod.toLowerCase() == 'cod' ||
              order.paymentMethod.toLowerCase() == 'cash on delivery')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8E1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.money_outlined,
                        color: const Color(0xFF8B6914),
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Cash On Delivery',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8B6914),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color:
                            (isPaid
                                    ? const Color(0xFF137333)
                                    : const Color(0xFFE8A000))
                                .withOpacity(0.4),
                      ),
                    ),
                    child: Text(
                      paymentStatus,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: isPaid
                            ? const Color(0xFF137333)
                            : const Color(0xFFB8860B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8A8A9E),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: valueColor ?? const Color(0xFF1E1E2F),
          ),
        ),
      ],
    );
  }
}
