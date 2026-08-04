import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';

// Radius Info Box
class RadiusInfoBox extends StatelessWidget {
  final double radius;

  const RadiusInfoBox({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? ShopAppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark
              ? ShopAppColors.darkBorder
              : ShopAppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: ShopAppColors.primary, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            // Delivery Area Info with KM
            child: RichText(
              text: TextSpan(
                style: ShopAppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextSecondary
                      : ShopAppColors.textSecondary,
                  height: 1.4,
                  fontSize: 12.sp,
                ),
                children: [
                  const TextSpan(
                    text: 'Your shop is currently visible to customers within ',
                  ),
                  TextSpan(
                    text: '${radius.toStringAsFixed(1)}km',
                    style: ShopAppTextStyles.bodyMediumBold.copyWith(
                      color: ShopAppColors.primary,
                      fontSize: 12.sp,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' of your location. Adjust the slider to expand or narrow your market reach.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
