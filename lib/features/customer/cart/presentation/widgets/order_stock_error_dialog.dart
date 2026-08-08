import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Confirm Order Stock validation Error Dialog
class OrderStockErrorDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String errorMessage;

  const OrderStockErrorDialog({
    super.key,
    required this.onConfirm,
    required this.errorMessage,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
    required String errorMessage,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => OrderStockErrorDialog(
        onConfirm: onConfirm,
        errorMessage: errorMessage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark
          ? CustomerAppColors.darkSurface
          : CustomerAppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: isDark ? CustomerAppColors.border : CustomerAppColors.border,
          width: 0.5,
        ),
      ),
      title: Row(
        children: [
          Icon(
            Icons.block_outlined,
            color: CustomerAppColors.error,
            size: 28.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            // Title
            child: Text(
              'Item Unavailable',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? CustomerAppColors.darkTextPrimary
                    : CustomerAppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        // Info content
        children: [
          Text(
            'Some items in your order are no longer available in the requested quantities. Please review and update your cart before proceeding.',
            style: TextStyle(
              fontSize: 14.sp,
              color: isDark ? Colors.grey[400] : Colors.grey[700],
            ),
          ),
          SizedBox(height: 16.h),
          // List of stock validation message
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200.h),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: errorMessage
                    .split('\n')
                    .where((s) => s.trim().isNotEmpty)
                    .map((issue) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.cancel_rounded,
                              color: CustomerAppColors.error,
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                issue.trim(),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: isDark
                                      ? Colors.grey[300]
                                      : Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      // Button for Ok
      actions: [
        TextButton(
          onPressed: onConfirm,
          style: TextButton.styleFrom(
            foregroundColor: CustomerAppColors.primary,
          ),
          child: Text(
            'OK',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
