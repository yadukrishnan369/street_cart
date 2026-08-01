import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class ProductImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final double? iconSize;
  final BorderRadius? borderRadius;
  final Color? iconColor;
  final Color? backgroundColor;

  const ProductImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.iconSize,
    this.borderRadius,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (isDark ? CustomerAppColors.darkInputBackground : Colors.grey[200]),
        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color:
              iconColor ??
              (isDark ? CustomerAppColors.darkTextSecondary : Colors.grey[400]),
          size: iconSize ?? 30.sp,
        ),
      ),
    );
  }
}
