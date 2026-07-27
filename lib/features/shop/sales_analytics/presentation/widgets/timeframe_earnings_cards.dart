import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Time frame Earnings Cards
class TimeframeEarningsCards extends StatelessWidget {
  final double todayEarnings;
  final double weekEarnings;
  final double monthEarnings;

  const TimeframeEarningsCards({
    super.key,
    required this.todayEarnings,
    required this.weekEarnings,
    required this.monthEarnings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildTimeframeCard(
            'TODAY',
            todayEarnings,
            const Color(0xFF0369A1),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildTimeframeCard(
            'WEEK',
            weekEarnings,
            ShopAppColors.primary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildTimeframeCard(
            'MONTH',
            monthEarnings,
            const Color(0xFF6D28D9),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeframeCard(String label, double val, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Time Frame Label
          Text(
            label,
            style: ShopAppTextStyles.caption.copyWith(
              color: ShopAppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          // Amount
          Text(
            '₹${PriceUtils.formatPriceWithoutDecimals(val)}',
            style: ShopAppTextStyles.bodyMediumBold.copyWith(
              color: color,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
