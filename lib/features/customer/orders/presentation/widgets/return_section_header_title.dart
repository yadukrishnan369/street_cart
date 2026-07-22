import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

// Return Section Header Title
class ReturnSectionHeaderTitle extends StatelessWidget {
  final String title;

  const ReturnSectionHeaderTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Title
    return Text(
      title,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w900,
        color: CustomerAppColors.primary,
        letterSpacing: 0.8,
      ),
    );
  }
}
