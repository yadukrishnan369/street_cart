import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';

// Order Payment Summary Card
class OrderPaymentSummaryCard extends StatelessWidget {
  final OrderModel order;

  const OrderPaymentSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
    final grandTotalStr = '₹${PriceUtils.formatPrice(subtotal)}';

    // Calculate commission percentage
    final double commissionPercentage =
        AdminOrdersHelper.calculateCommissionPercentage(order);
    final commissionPercentStr = commissionPercentage > 0
        ? ' (${commissionPercentage.toStringAsFixed(1)}%)'
        : '';

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            // Title
            child: Text(
              'Payment Summary',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AdminAppColors.darkTextPrimary
                    : AdminAppColors.textPrimary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                // Sub Total Section
                _buildSummaryRow(context, 'Subtotal', subtotalStr),
                SizedBox(height: 12.h),
                // Commission Percentage Section
                _buildSummaryRow(
                  context,
                  'Commission$commissionPercentStr',
                  commStr,
                  valueColor: AdminAppColors.successColor,
                ),
                SizedBox(height: 12.h),
                // After Deduction Amount
                _buildSummaryRow(context, 'After Deduction', deductionStr),
                SizedBox(height: 16.h),
                Divider(
                  color: isDark
                      ? AdminAppColors.darkBorder
                      : const Color(0xFFE8E7ED),
                  thickness: 1.2,
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Grand Total
                    Text(
                      'Grand Total',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AdminAppColors.darkTextPrimary
                            : AdminAppColors.textPrimary,
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
              decoration: BoxDecoration(
                color: isDark
                    ? AdminAppColors.primaryColor.withValues(alpha: 0.15)
                    : const Color(0xFFF0EEFC),
                borderRadius: const BorderRadius.only(
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
                        color: isDark
                            ? AdminAppColors.darkTextSecondary
                            : const Color(0xFF6C6C80),
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      // Payment Method
                      Text(
                        'Payment Via ${order.paymentMethod.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AdminAppColors.darkTextSecondary
                              : const Color(0xFF6C6C80),
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
                      color: isDark
                          ? AdminAppColors.darkInputBackground
                          : Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color:
                            (isPaid
                                    ? AdminAppColors.successColor
                                    : AdminAppColors.warningColor)
                                .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      paymentStatus,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: isPaid
                            ? AdminAppColors.successColor
                            : AdminAppColors.warningColor,
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
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFFFFF8E1).withValues(alpha: 0.15)
                    : const Color(0xFFFFF8E1),
                borderRadius: const BorderRadius.only(
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
                        color: AdminAppColors.warningColor,
                        size: 18.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Cash On Delivery',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AdminAppColors.warningColor,
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
                      color: isDark
                          ? AdminAppColors.darkInputBackground
                          : Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color:
                            (isPaid
                                    ? AdminAppColors.successColor
                                    : AdminAppColors.warningColor)
                                .withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      paymentStatus,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: isPaid
                            ? AdminAppColors.successColor
                            : AdminAppColors.warningColor,
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

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AdminAppColors.darkTextSecondary
                : const Color(0xFF8A8A9E),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color:
                valueColor ??
                (isDark
                    ? AdminAppColors.darkTextPrimary
                    : AdminAppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
