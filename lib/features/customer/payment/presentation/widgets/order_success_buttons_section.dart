import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/home/presentation/pages/home_page.dart';

class OrderSuccessButtonsSection extends StatelessWidget {
  const OrderSuccessButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Track Order Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            },
            icon: Icon(
              Icons.local_shipping_outlined,
              size: 20.sp,
              color: Colors.white,
            ),
            label: Text(
              'Track Order',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomerAppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              elevation: 0,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Continue Shopping Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: CustomerAppColors.textPrimary,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            child: Text(
              'Continue Shopping',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
