import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class ShopsEmptyState extends StatelessWidget {
  final bool isSearching;

  const ShopsEmptyState({
    super.key,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : Icons.storefront_outlined,
            size: 80.sp,
            color: CustomerAppColors.primary.withValues(alpha: 0.25),
          ),
          SizedBox(height: 20.h),
          Text(
            isSearching ? 'No shops found' : 'No shops nearby',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: CustomerAppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            isSearching
                ? 'Try a different search term'
                : "We're expanding to your area soon!",
            style: TextStyle(
              fontSize: 13.sp,
              color: CustomerAppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
