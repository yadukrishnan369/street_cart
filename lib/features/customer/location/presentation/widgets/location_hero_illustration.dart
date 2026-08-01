import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Location Hero Illustration
class LocationHeroIllustration extends StatelessWidget {
  const LocationHeroIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 240.w,
      width: 240.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomerAppColors.primary.withValues(
                alpha: isDark ? 0.1 : 0.05,
              ),
            ),
          ),
          Container(
            width: 176.w,
            height: 176.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomerAppColors.primary.withValues(
                alpha: isDark ? 0.2 : 0.12,
              ),
            ),
          ),
          Container(
            width: 112.w,
            height: 112.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomerAppColors.primary.withValues(
                alpha: isDark ? 0.3 : 0.2,
              ),
            ),
          ),
          Container(
            width: 64.w,
            height: 64.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CustomerAppColors.primary,
            ),
            child: Center(
              child: Icon(Icons.location_on, color: Colors.white, size: 32.w),
            ),
          ),
          Positioned(bottom: 20, child: _circleIcon(context, Icons.store)),
          Positioned(
            bottom: 40,
            left: 40,
            child: _circleIcon(context, Icons.shopping_bag),
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: _circleIcon(context, Icons.local_shipping),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(BuildContext context, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? CustomerAppColors.darkInputBackground : Colors.white,
        border: isDark ? Border.all(color: CustomerAppColors.darkBorder) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.12),
            blurRadius: 6,
          ),
        ],
      ),
      child: Icon(icon, size: 20.w, color: CustomerAppColors.primary),
    );
  }
}
