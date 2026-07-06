import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class ProductsEmptyState extends StatelessWidget {
  const ProductsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: constraints.maxHeight > 0 ? constraints.maxHeight : 400.h,
          alignment: Alignment.center,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 50.sp,
                color: CustomerAppColors.primary,
              ),
              SizedBox(height: 12.h),
              Text(
                "No products found",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomerAppColors.primary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "No products match your search or filter options.",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: CustomerAppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
