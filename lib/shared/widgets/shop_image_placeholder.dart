import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class ShopImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final double? iconSize;
  final BorderRadius? borderRadius;

  const ShopImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.iconSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? CustomerAppColors.primary.withValues(alpha: 0.15)
            : CustomerAppColors.primaryLight,
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      child: Center(
        child: Icon(
          Icons.storefront_rounded,
          size: iconSize ?? 56.sp,
          color: CustomerAppColors.primary.withValues(
            alpha: isDark ? 0.6 : 0.4,
          ),
        ),
      ),
    );
  }
}
