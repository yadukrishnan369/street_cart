import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

// Radius Map Preview
class RadiusMapPreview extends StatelessWidget {
  final double radius;

  const RadiusMapPreview({super.key, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFECEFF1), width: 0.8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              // Map Image
              child: Image.asset(
                'assets/images/shop_location_map.png',
                fit: BoxFit.cover,
              ),
            ),
            // Delivery Radius Dummy Circle
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 30.h + (radius / 500.0) * 150.h,
              height: 30.h + (radius / 500.0) * 150.h,
              decoration: BoxDecoration(
                color: ShopAppColors.primary.withAlpha(38),
                shape: BoxShape.circle,
                border: Border.all(color: ShopAppColors.primary, width: 2.r),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: ShopAppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.storefront, color: Colors.white, size: 20.sp),
            ),
          ],
        ),
      ),
    );
  }
}
