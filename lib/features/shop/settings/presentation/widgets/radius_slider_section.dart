import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'green_border_thumb_shape.dart';

// Radius Slider Section
class RadiusSliderSection extends StatelessWidget {
  final double radius;
  final ValueChanged<double> onChanged;

  const RadiusSliderSection({
    super.key,
    required this.radius,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Page Title
              children: [
                Text(
                  'Delivery Radius',
                  style: ShopAppTextStyles.bodyMediumBold.copyWith(
                    fontSize: 16.sp,
                    color: isDark
                        ? ShopAppColors.darkTextPrimary
                        : ShopAppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                // Subtitle
                Text(
                  'Set the maximum distance for orders',
                  style: ShopAppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? ShopAppColors.darkTextSecondary
                        : ShopAppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: ShopAppColors.primary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              // Delivery Radius KM
              child: Text(
                '${radius.toStringAsFixed(1)} km',
                style: ShopAppTextStyles.bodyMediumBold.copyWith(
                  color: Colors.white,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // Delivery Radius Slider Section
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6.h,
            activeTrackColor: ShopAppColors.primary,
            inactiveTrackColor: isDark
                ? ShopAppColors.darkInputBackground
                : const Color(0xFFD2E7E2),
            thumbShape: GreenBorderThumbShape(thumbRadius: 10.r),
            overlayColor: ShopAppColors.primary.withValues(alpha: 0.12),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.r),
          ),
          child: Slider(
            value: radius,
            min: 0.0,
            max: 500.0,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 KM',
                style: ShopAppTextStyles.bodySmallBold.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextSecondary
                      : ShopAppColors.textSecondary,
                  fontSize: 10.sp,
                ),
              ),
              Text(
                '250 KM',
                style: ShopAppTextStyles.bodySmallBold.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextSecondary
                      : ShopAppColors.textSecondary,
                  fontSize: 10.sp,
                ),
              ),
              Text(
                '500 KM',
                style: ShopAppTextStyles.bodySmallBold.copyWith(
                  color: isDark
                      ? ShopAppColors.darkTextSecondary
                      : ShopAppColors.textSecondary,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
