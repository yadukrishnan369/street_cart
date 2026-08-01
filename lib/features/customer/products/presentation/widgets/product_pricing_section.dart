import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';

// Product Price Section
class ProductPricingSection extends StatelessWidget {
  final double originalPrice;
  final double? offerPrice;

  const ProductPricingSection({
    super.key,
    required this.originalPrice,
    this.offerPrice,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final originalPriceText = '₹${PriceUtils.formatPrice(originalPrice)}';
    final offerPriceText = offerPrice != null
        ? '₹${PriceUtils.formatPrice(offerPrice!)}'
        : null;
    // Calculate Offer Percentage
    int discountPercent = 0;
    if (offerPrice != null) {
      discountPercent = PriceUtils.calculateOfferPercentage(
        originalPrice,
        offerPrice!,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // Main Product Price - If Offer Available, considered. otherwise take Original Price.
        Text(
          offerPriceText ?? originalPriceText,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: isDark
                ? CustomerAppColors.darkTextPrimary
                : CustomerAppColors.textPrimary,
          ),
        ),
        if (offerPriceText != null) ...[
          SizedBox(width: 8.w),
          // Original Price
          Text(
            originalPriceText,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          SizedBox(width: 8.w),
          // Discount Price
          Text(
            '$discountPercent% OFF',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF10B981),
            ),
          ),
        ],
      ],
    );
  }
}
