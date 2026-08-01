import 'package:flutter/material.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class CustomerImagePlaceholder extends StatelessWidget {
  final double size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  const CustomerImagePlaceholder({
    super.key,
    required this.size,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            (isDark ? CustomerAppColors.darkInputBackground : Colors.grey[200]),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.person,
          size: iconSize ?? (size * 0.5),
          color: iconColor ?? CustomerAppColors.primary,
        ),
      ),
    );
  }
}
