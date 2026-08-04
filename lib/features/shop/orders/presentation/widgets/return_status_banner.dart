import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Return Status Banner
class ReturnStatusBanner extends StatelessWidget {
  final String returnStatus;
  final String? refundStatus;
  final double? refundAmount;

  const ReturnStatusBanner({
    super.key,
    required this.returnStatus,
    this.refundStatus,
    this.refundAmount,
  });

  @override
  Widget build(BuildContext context) {
    String text = 'Return Requested';
    String subtitle = 'Customer return request pending';
    Color mainColor = ShopAppColors.error;

    if (returnStatus == 'return_confirmed') {
      text = 'Return Accepted';
      subtitle = 'Waiting for pickup';
    } else if (returnStatus == 'return_picked') {
      if (refundStatus == 'refunded') {
        text = 'Refund Completed';
        final amountText = refundAmount != null
            ? ' of ₹${PriceUtils.formatPrice(refundAmount!)}'
            : '';
        subtitle = 'Refund$amountText processed successfully';
        mainColor = ShopAppColors.success;
      } else if (refundStatus == 'processing') {
        text = 'Refund Processing';
        subtitle = 'Refund is being processed';
        mainColor = ShopAppColors.warning;
      } else {
        text = 'Return Picked Up';
        subtitle = 'Item returned successfully';
        mainColor = ShopAppColors.error;
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: mainColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: mainColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(color: mainColor, shape: BoxShape.circle),
            child: Icon(
              returnStatus == 'return_picked'
                  ? Icons.check_circle_outline
                  : Icons.assignment_return_outlined,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                SizedBox(height: 4.h),
                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: mainColor.withAlpha(170),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
