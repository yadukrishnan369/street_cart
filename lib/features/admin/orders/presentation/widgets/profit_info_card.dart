import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/utils/price_utils.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/features/admin/orders/presentation/utils/admin_orders_helper.dart';

class ProfitInfoCard extends StatelessWidget {
  final OrderModel order;

  const ProfitInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final commission = AdminOrdersHelper.calculateCommission(order);
    final vendorEarnings = AdminOrdersHelper.calculateVendorEarnings(order);

    final totalStr = '₹${PriceUtils.formatPrice(order.totalAmount)}';
    final vendorStr = '₹${PriceUtils.formatPrice(vendorEarnings)}';
    final profitStr = '₹${PriceUtils.formatPrice(commission)}';

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: const Color(0xFF7B2CBF),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Profit Information',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E1E2F),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildProfitItem('Total Amount', totalStr, isBoldValue: true),
          SizedBox(height: 16.h),
          _buildProfitItem('Vendor Earnings', vendorStr, isBoldValue: true),
          SizedBox(height: 16.h),
          _buildProfitItem(
            'Street cart Profit',
            profitStr,
            isBoldValue: true,
            valueColor: const Color(0xFF137333),
            valueSize: 18.sp,
          ),
        ],
      ),
    );
  }

  Widget _buildProfitItem(
    String label,
    String value, {
    bool isBoldValue = false,
    Color? valueColor,
    double? valueSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF8A8A9E),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: valueSize ?? 15.sp,
            fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
            color: valueColor ?? const Color(0xFF1E1E2F),
          ),
        ),
      ],
    );
  }
}
