import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class LocationHeroIllustration extends StatelessWidget {
  const LocationHeroIllustration({super.key});

  @override
  Widget build(BuildContext context) {
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
              color: CustomerAppColors.primary.withOpacity(0.05),
            ),
          ),
          Container(
            width: 176.w,
            height: 176.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomerAppColors.primary.withOpacity(0.12),
            ),
          ),
          Container(
            width: 112.w,
            height: 112.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomerAppColors.primary.withOpacity(0.2),
            ),
          ),
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomerAppColors.primary,
            ),
            child: Center(
              child: Icon(Icons.location_on, color: Colors.white, size: 32.w),
            ),
          ),
          Positioned(bottom: 20, child: _circleIcon(Icons.store)),
          Positioned(
            bottom: 40,
            left: 40,
            child: _circleIcon(Icons.shopping_bag),
          ),
          Positioned(
            bottom: 40,
            right: 40,
            child: _circleIcon(Icons.local_shipping),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CustomerAppColors.surface,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Icon(icon, size: 20.w, color: CustomerAppColors.primary),
    );
  }
}
