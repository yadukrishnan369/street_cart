import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';

// Checkout Summary Section
class CheckoutSummarySection extends StatelessWidget {
  final List<CartItem> cartItems;
  final int productTypesCount;
  final int totalProductsCount;
  final double totalAmount;

  const CheckoutSummarySection({
    super.key,
    required this.cartItems,
    required this.productTypesCount,
    required this.totalProductsCount,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.darkSurface
            : CustomerAppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? CustomerAppColors.darkBorder
              : Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? CustomerAppColors.darkTextPrimary
                  : CustomerAppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          // Product detail listing
          Column(
            children: cartItems.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark
                              ? CustomerAppColors.darkTextSecondary
                              : CustomerAppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '₹${item.price.toStringAsFixed(0)} x ${item.quantity}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? CustomerAppColors.darkTextSecondary
                            : CustomerAppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          Divider(
            color: isDark
                ? CustomerAppColors.darkBorder
                : CustomerAppColors.border,
          ),
          SizedBox(height: 12.h),
          // Product Section
          _buildRow(context, 'Product Types', '$productTypesCount'),
          SizedBox(height: 8.h),
          // Total Quantity Section
          _buildRow(context, 'Total Quantity', '$totalProductsCount'),
          SizedBox(height: 12.h),
          Divider(
            color: isDark
                ? CustomerAppColors.darkBorder
                : CustomerAppColors.border,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? CustomerAppColors.darkTextPrimary
                      : CustomerAppColors.textPrimary,
                ),
              ),
              Text(
                '₹${totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomerAppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: isDark
                ? CustomerAppColors.darkTextSecondary
                : CustomerAppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
