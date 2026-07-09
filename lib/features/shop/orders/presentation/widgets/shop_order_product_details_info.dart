import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

class ShopOrderProductDetailsInfo extends StatelessWidget {
  final OrderItemModel item;

  const ShopOrderProductDetailsInfo({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final total = item.price * item.quantity;

    return Container(
      margin: EdgeInsets.all(16.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item Specification',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const Divider(),
          _buildRow('Selected Size', item.selectedSize ?? 'Default Size'),
          _buildRow('Selected Color', item.selectedColor ?? 'Default Color'),
          _buildRow('Quantity', 'x${item.quantity}'),
          _buildRow('Unit Price', '₹${item.price.toStringAsFixed(0)}'),
          _buildRow('Subtotal', '₹${total.toStringAsFixed(0)}', isBold: true),
          SizedBox(height: 16.h),
          Text(
            'Earnings Breakdown',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const Divider(),
          _buildRow(
            'Admin Commission',
            '-₹${item.adminCommission.toStringAsFixed(0)}',
            valueColor: Colors.red[700],
          ),
          _buildRow(
            'Your Earnings',
            '₹${item.vendorEarnings.toStringAsFixed(0)}',
            valueColor: const Color(0xFF10B981),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[600],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: valueColor ?? const Color(0xFF1E293B),
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
