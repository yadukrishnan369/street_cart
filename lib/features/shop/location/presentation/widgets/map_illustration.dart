import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';

class MapIllustration extends StatelessWidget {
  const MapIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,
      width: 240.h,
      decoration: BoxDecoration(
        color: ShopAppColors.primary.withAlpha(26),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 180.h,
              width: 180.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                shape: BoxShape.rectangle,
                image: const DecorationImage(
                  image: AssetImage('assets/images/shop_location_map.png'),
                  fit: BoxFit.cover,
                  opacity: 10,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: ShopAppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.storefront, color: Colors.white, size: 24.sp),
            ),
          ],
        ),
      ),
    );
  }
}
