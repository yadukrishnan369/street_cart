import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';

// Profit Info Card
class ProfitInfoCard extends StatelessWidget {
  final OrderModel order;

  const ProfitInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final commission = AdminOrdersHelper.calculateCommission(order);
    final vendorEarnings = AdminOrdersHelper.calculateVendorEarnings(order);

    final totalStr = '₹${PriceUtils.formatPrice(order.totalAmount)}';
    final vendorStr = '₹${PriceUtils.formatPrice(vendorEarnings)}';
    final profitStr = '₹${PriceUtils.formatPrice(commission)}';

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AdminAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AdminAppColors.darkBorder : const Color(0xFFE8E7ED),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AdminAppColors.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              // Title
              Text(
                'Profit Information',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AdminAppColors.darkTextPrimary
                      : AdminAppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Total Amount Section
          _buildProfitItem(
            context,
            'Total Amount',
            totalStr,
            isBoldValue: true,
          ),
          SizedBox(height: 16.h),
          // Vendor Earning Section
          _buildProfitItem(
            context,
            'Vendor Earnings',
            vendorStr,
            isBoldValue: true,
          ),
          SizedBox(height: 16.h),
          // PlatForm Profit Section
          _buildProfitItem(
            context,
            'Street cart Profit',
            profitStr,
            isBoldValue: true,
            valueColor: AdminAppColors.successColor,
            valueSize: 18.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildProfitItem(
    BuildContext context,
    String label,
    String value, {
    bool isBoldValue = false,
    Color? valueColor,
    double? valueSize,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark
                ? AdminAppColors.darkTextSecondary
                : const Color(0xFF8A8A9E),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: valueSize ?? 15.sp,
            fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
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
