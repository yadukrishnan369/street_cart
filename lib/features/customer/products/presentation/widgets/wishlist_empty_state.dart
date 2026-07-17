import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Wish List Empty State
class WishlistEmptyState extends StatelessWidget {
  const WishlistEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 64.sp,
            color: CustomerAppColors.error,
          ),
          SizedBox(height: 16.h),
          // Title
          Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: CustomerAppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          // Subtitle
          Text(
            'Explore products to add them to your wishlist.',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[500]),
          ),
          SizedBox(height: 24.h),
          // Button for navigate to Products Page
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomerAppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: const Text('Explore Products'),
          ),
        ],
      ),
    );
  }
}
