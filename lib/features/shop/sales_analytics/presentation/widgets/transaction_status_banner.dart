import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/customer/orders/data/models/order_model.dart';

// Transaction Status Banner
class TransactionStatusBanner extends StatelessWidget {
  final OrderModel order;
  final String? transactionStatus;

  const TransactionStatusBanner({
    super.key,
    required this.order,
    this.transactionStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final status = (transactionStatus ?? order.status).toLowerCase();
    final isCancelled = status == 'cancelled';
    final isReturned =
        status == 'returned' ||
        (order.returnStatus != null &&
            order.returnStatus!.isNotEmpty &&
            transactionStatus == null);

    Color bannerColor = ShopAppColors.success;
    String bannerText = 'Order Delivered Successfully';
    IconData bannerIcon = Icons.check_circle_outline;

    // Cancelled Banner styles
    if (isCancelled) {
      bannerColor = ShopAppColors.error;
      bannerText = 'Order Cancelled';
      bannerIcon = Icons.cancel_outlined;
      // Returned Banner styles
    } else if (isReturned) {
      bannerColor = ShopAppColors.warning;
      bannerText = 'Order Returned';
      bannerIcon = Icons.keyboard_return_outlined;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      color: bannerColor.withValues(alpha: isDark ? 0.15 : 0.08),
      child: Row(
        children: [
          Icon(bannerIcon, color: bannerColor, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            // Banner Text
            child: Text(
              bannerText,
              style: TextStyle(
                color: bannerColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
