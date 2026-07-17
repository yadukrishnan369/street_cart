import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Order Summary
class OrderSummary extends StatelessWidget {
  final int totalItems;
  final int productTypes;
  final double subtotal;
  final double totalAmount;
  final bool isVisible;

  const OrderSummary({
    super.key,
    required this.totalItems,
    required this.productTypes,
    required this.subtotal,
    required this.totalAmount,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      height: isVisible ? 220.h : 0,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: AnimatedSlide(
        offset: isVisible ? Offset.zero : const Offset(0, 1.2),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: CustomerAppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
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
                        color: CustomerAppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Products
                    _summaryRow('Product Types', '$productTypes'),
                    SizedBox(height: 8.h),
                    // Total Quantity
                    _summaryRow('Total Quantity', '$totalItems'),
                    SizedBox(height: 8.h),
                    // Calculated Subtotals
                    _summaryRow('Subtotal', '₹${subtotal.toStringAsFixed(0)}'),
                    SizedBox(height: 12.h),
                    const Divider(color: CustomerAppColors.border),
                    SizedBox(height: 12.h),
                    // Total Amount Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: CustomerAppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '₹${totalAmount.toStringAsFixed(0)}',
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
              ),
              SizedBox(height: 28.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: CustomerAppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: CustomerAppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
