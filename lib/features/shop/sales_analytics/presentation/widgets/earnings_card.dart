import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Earnings Card
class EarningsCard extends StatelessWidget {
  final double totalEarnings;

  const EarningsCard({super.key, required this.totalEarnings});

  @override
  Widget build(BuildContext context) {
    final formattedAmount = PriceUtils.formatPriceWithoutDecimals(
      totalEarnings,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF045C3A), Color(0xFF02442A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF045C3A).withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Total Earnings',
                  style: ShopAppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                // Total Earnings Amount
                Text(
                  '₹$formattedAmount',
                  style: ShopAppTextStyles.heading1.copyWith(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 16.h),
                // Subtitle
                Text(
                  'Total earnings from completed orders',
                  style: ShopAppTextStyles.caption.copyWith(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          // Icon
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
        ],
      ),
    );
  }
}
