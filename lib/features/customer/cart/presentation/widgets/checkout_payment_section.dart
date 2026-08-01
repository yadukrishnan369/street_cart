import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Checkout Payment Method Section
class CheckoutPaymentSection extends StatelessWidget {
  final List<String> allowedMethods;
  final String selectedMethod;
  final ValueChanged<String> onMethodSelected;

  const CheckoutPaymentSection({
    super.key,
    required this.allowedMethods,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Methods',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        if (allowedMethods.contains('UPI')) ...[
          _buildPaymentCard(
            methodKey: 'UPI',
            title: 'UPI (Online Payment)',
            subtitle: 'Pay directly from your bank account',
            icon: Icons.account_balance_wallet_outlined,
          ),
          SizedBox(height: 12.h),
        ],
        if (allowedMethods.contains('COD')) ...[
          _buildPaymentCard(
            methodKey: 'COD',
            title: 'Cash on Delivery',
            subtitle: 'Pay when you receive the order',
            icon: Icons.payments_outlined,
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentCard({
    required String methodKey,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = selectedMethod == methodKey;

    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return GestureDetector(
          onTap: () => onMethodSelected(methodKey),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark
                  ? CustomerAppColors.darkSurface
                  : CustomerAppColors.surface,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected
                    ? CustomerAppColors.primary
                    : (isDark
                          ? CustomerAppColors.darkBorder
                          : Colors.grey.withValues(alpha: 0.1)),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? CustomerAppColors.primary
                      : (isDark ? Colors.grey[400] : Colors.grey),
                  size: 24.sp,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? CustomerAppColors.darkTextPrimary
                              : CustomerAppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark
                              ? CustomerAppColors.darkTextSecondary
                              : CustomerAppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20.w,
                  width: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? CustomerAppColors.primary
                          : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Container(
                          margin: EdgeInsets.all(3.w),
                          decoration: const BoxDecoration(
                            color: CustomerAppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
