import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Shop Order Product Details Info
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
          // Title
          Text(
            'Item Specification',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const Divider(),
          // Selected Size
          _buildRow('Selected Size', item.selectedSize ?? 'Default Size'),
          // Selected Color
          _buildRow('Selected Color', item.selectedColor ?? 'Default Color'),
          // Item Quantity
          _buildRow('Quantity', 'x${item.quantity}'),
          // Item Price
          _buildRow('Unit Price', '₹${PriceUtils.formatPrice(item.price)}'),
          // SubTotal
          _buildRow(
            'Subtotal',
            '₹${PriceUtils.formatPrice(total)}',
            isBold: true,
          ),
          SizedBox(height: 16.h),
          // Earning section Title
          Text(
            'Earnings Breakdown',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const Divider(),
          // Admin Commision Amount
          _buildRow(
            'Admin Commission',
            '-₹${PriceUtils.formatPrice(item.adminCommission)}',
            valueColor: Colors.red[700],
          ),
          // Shop Earnings
          _buildRow(
            'Your Earnings',
            '₹${PriceUtils.formatPrice(item.vendorEarnings)}',
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
