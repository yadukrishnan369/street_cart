import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/location/presentation/pages/location_permission_page.dart';

class ShopsLocationDisabled extends StatelessWidget {
  final VoidCallback onRefreshLocation;

  const ShopsLocationDisabled({
    super.key,
    required this.onRefreshLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 80.sp,
              color: CustomerAppColors.primary.withValues(alpha: 0.25),
            ),
            SizedBox(height: 20.h),
            Text(
              'Location Services Off',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: CustomerAppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Enable location services to find local shops near you.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: CustomerAppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LocationPermissionPage(
                      isProfileCompleted: true,
                    ),
                  ),
                ).then((_) => onRefreshLocation());
              },
              icon: const Icon(Icons.my_location),
              label: const Text('Enable Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomerAppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
