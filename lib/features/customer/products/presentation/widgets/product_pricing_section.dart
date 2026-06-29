import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/core/utils/price_utils.dart';

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
    final originalPriceText = '₹${PriceUtils.formatPrice(originalPrice)}';
    final offerPriceText = offerPrice != null
        ? '₹${PriceUtils.formatPrice(offerPrice!)}'
        : null;

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
        Text(
          offerPriceText ?? originalPriceText,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: CustomerAppColors.textPrimary,
          ),
        ),
        if (offerPriceText != null) ...[
          SizedBox(width: 8.w),
          Text(
            originalPriceText,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          SizedBox(width: 8.w),
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
