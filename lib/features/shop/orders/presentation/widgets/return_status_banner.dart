import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Return Status Banner
class ReturnStatusBanner extends StatelessWidget {
  final String returnStatus;

  const ReturnStatusBanner({super.key, required this.returnStatus});

  @override
  Widget build(BuildContext context) {
    String text = 'Return Requested';
    if (returnStatus == 'return_confirmed') text = 'Return Accepted';
    if (returnStatus == 'return_picked') text = 'Return Picked Up';
    final mainColor = ShopAppColors.error;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: mainColor.withOpacity(0.2)),
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
                  returnStatus == 'return_picked'
                      ? 'Item returned successfully'
                      : returnStatus == 'return_confirmed'
                      ? 'Waiting for pickup'
                      : 'Customer return request pending',
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
